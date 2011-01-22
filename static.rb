run "curl -s -L https://github.com/benlangfeld/rails-templates/raw/master/resources/static/static_controller.rb > app/controllers/static_controller.rb"
run "mkdir app/views/static"
run "curl -s -L https://github.com/benlangfeld/rails-templates/raw/master/resources/static/home.html.erb > app/views/static/home.html.erb"

route "root :to => 'static#home'"

git :add => ".", :commit => "-m 'Static home page'"