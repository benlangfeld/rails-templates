gem 'authlogic', :git => "git://github.com/odorcicd/authlogic.git", :branch => "rails3"
run "bundle install"

generate('nifty:scaffold', "user username:string email:string password:string")

generate(:migration, "AddAuthlogicToUsers")
run "curl -s -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/add_authlogic_to_users.rb > db/migrate/temp.rb"
inside ('db/migrate') do
  #this grabs the new migration in your newly generated app
  run "find *_add_authlogic_to_users.rb | xargs mv temp.rb"
end
maybe_update_file :file => "app/views/users/_form.html.erb", :action => "update user form with password confirmation",
                  :unless_present => /confirmation/, :before => "<p><%= f.submit %></p>",
                  :content => (<<-CODE).gsub(/\A +| +\Z/, '')
                  <p>
                    <%= f.label :password_confirmation %><br />
                    <%= f.password_field :password_confirmation %>
                  </p>
                  CODE

#Generate user_session model, then copy views and controller
generate('authlogic:session', "user_session")
run "mkdir app/views/user_sessions"
run "curl -s -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/new.html.erb > app/views/user_sessions/new.html.erb"
run "curl -s -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/user_sessions_controller.rb > app/controllers/user_sessions_controller.rb"

maybe_update_file :file => "app/models/user.rb", :action => "make User model act as authentication source", :unless_present => /authentic/,
                  :after => "class User < ActiveRecord::Base", :content => "  acts_as_authentic"

maybe_update_file :file => "app/controllers/application_controller.rb", :action => "update application controller",
                  :unless_present => /authentic/, :before => "end", :content => (<<-CODE).gsub(/\A +| +\Z/, '')

                  helper :all
                  helper_method :current_user

                  private

                  def current_user_session
                    return @current_user_session if defined?(@current_user_session)
                    @current_user_session = UserSession.find
                  end

                  def current_user
                    return @current_user if defined?(@current_user)
                    @current_user = current_user_session && current_user_session.record
                  end

                  CODE

maybe_update_file :file => "app/controllers/users_controller.rb", :action => "update users controller",
                  :unless_present => /current/, :after => "def edit", :content => (<<-CODE).gsub(/\A +| +\Z/, '')

                  if params[:id] == "current"
                    id = current_user.id
                  else
                    id = params[:id]
                  end

                  CODE

if FileTest.exists?('app/views/layouts/application.html.erb')
maybe_update_file :file => "app/views/layouts/application.html.erb", :action => "update nifty_layout with user_nav block",
                  :unless_present => /user_nav/, :after => "<div id=\"container\">", :content => (<<-CODE).gsub(/\A +| +\Z/, '')

                  <div id="user_nav">
                    <% if current_user %>
                      <%= link_to "Edit Profile", edit_user_path(:current) %> |
                      <%= link_to "Logout", logout_path %>
                    <% else %>
                      <%= link_to "Register", new_user_path %> |
                      <%= link_to "Login", login_path %>
                    <% end %>
                  </div>

                  CODE
end

if FileTest.exists?('public/stylesheets/application.css')
maybe_update_file :file => "public/stylesheets/application.css", :action => "update stylesheet with user_nav block",
                  :unless_present => /user_nav/, :before => "body", :content => (<<-CODE).gsub(/\A +| +\Z/, '')

                  #user_nav {
                    float: right;
                    font-size: 12px;
                  }

                  CODE

end

route 'match \'login\' => \'user_sessions#new\''
route 'match \'logout\' => \'user_sessions#destroy\''
route 'resources :user_sessions'

git :add => ".", :commit => "-m 'Added Authlogic'"