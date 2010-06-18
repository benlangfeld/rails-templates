gem 'authlogic', :git => "git://github.com/odorcicd/authlogic.git", :branch => "rails3"
run "bundle install"

generate('nifty:scaffold', "user username:string email:string password:string new edit")
generate('authlogic:session', "user_session")
generate('nifty:scaffold', "user_session --skip-model username:string password:string new destroy")

#run "curl -s -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/user_sessions_controller.rb > app/controllers/user_sessions_controller.rb"

maybe_update_file :file => "app/models/user.rb", :action => "make User model act as authentication source", :unless_present => /authentic/,
                  :after => "class User < ActiveRecord::Base", :content => "  acts_as_authentic"
                  
maybe_update_file :file => "app/controllers/application_controller.rb", :action => "update application controller", 
                  :unless_present => /authentic/, :after => "class ApplicationController < ActionController::Base",
                  :content => (<<-CODE).gsub(/\A +| +\Z/, '')
                  
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

route 'match \'login\' => \'user_sessions#new\''
route 'match \'logout\' => \'user_sessions#destroy\''

git :add => ".", :commit => "-m 'Authlogic'"