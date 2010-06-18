gem 'declarative_authorization', :git => "git://github.com/stffn/declarative_authorization.git"
run "bundle install"

run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/declarative_authorization/application_controller.rb > app/controllers/application_controller.rb"
run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/declarative_authorization/authorization_rules > config/authorization_rules.rb"
run "curl -L http://github.com/benlangfeld/rails-templates/raw/master/resources/declarative_authorization/user.rb > app/models/user.rb"

git :add => ".", :commit => "-m 'Declarative Authorization'"

puts "You still need to specify restrictions in controllers and views."