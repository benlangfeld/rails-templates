@stategies << lambda do
  get "#{TEMPLATES_PATH}/resources/static/static_controller.rb", "app/controllers/static_controller.rb"
  run "mkdir app/views/static"
  get "#{TEMPLATES_PATH}/resources/static/home.html.erb", "app/views/static/home.html.erb"

  route "root :to => 'static#home'"

  commit_all 'Static home page'
end
