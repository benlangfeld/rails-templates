gem 'authlogic', :git => "git://github.com/odorcicd/authlogic.git", :branch => "rails3"
run "bundle install"

generate('nifty:scaffold', "user username:string email:string password:string new edit")
generate('session', "user_session")
generate('nifty:scaffold', "user_session --skip-model username:string password:string new destroy")

run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/application_controller.rb > app/controllers/application_controller.rb"
run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/user_sessions_controller.rb > app/controllers/user_sessions_controller.rb"
run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/users_controller.rb > app/controllers/users_controller.rb"
run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/user.rb > app/models/user.rb"
run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/authlogic/user_session.rb > app/models/user_session.rb"

route 'match \'login\' => \'user_sessions#new\''
route 'match \'logout\' => \'user_sessions#destroy\''

git :add => ".", :commit => "-m 'Authlogic'"