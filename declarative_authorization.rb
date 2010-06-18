gem 'declarative_authorization', :git => "git://github.com/stffn/declarative_authorization.git"
run "bundle install"

run "curl -s -L http://github.com/benlangfeld/rails-templates/raw/master/resources/declarative_authorization/authorization_rules > config/authorization_rules.rb"

maybe_update_file :file => "app/model/user.rb", :action => "update user model for role_symbols", 
                  :unless_present => /role_symbols/, :before => "end", :content => (<<-CODE).gsub(/\A +| +\Z/, '')

                  def role_symbols
                    rolesymbols = []
                    rolesymbols += [:member]
                    rolesymbols
                  end
                  
                  CODE
                  
maybe_update_file :file => "app/controllers/application_controller.rb", :action => "update application controller for permission_denied", 
                  :unless_present => /permission_denied/, :before => "end", :content => (<<-CODE).gsub(/\A +| +\Z/, '')
                  
                  protected

                  def permission_denied
                    flash[:error] = "Sorry, you are not allowed to access that page."
                    redirect_to root_url
                  end

                  CODE

git :add => ".", :commit => "-m 'Declarative Authorization'"

puts "You still need to specify restrictions in controllers and views."