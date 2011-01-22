run "curl -s -L #{templates_path}/resources/static/static_controller.rb > app/controllers/static_controller.rb"
run "mkdir app/views/static"
run "curl -s -L #{templates_path}/resources/static/home.html.erb > app/views/static/home.html.erb"

route "root :to => 'static#home'"

git :add => ".", :commit => "-m 'Static home page'"