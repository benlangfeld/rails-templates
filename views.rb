if SETTINGS['haml']
  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.template_engine :haml\n"
  end

  create_file "config/initializers/haml.rb" do
    <<-HAML
    Haml::Template.options[:attr_wrapper] = '\"'
    Haml::Template.options[:format] = :xhtml
    Sass::Plugin.options[:style] = :expanded
    HAML
  end

  commit_all 'Use HAML'
end

if SETTINGS['jquery']
  generate "jquery:install", "--ui"
  git :add => ".", :rm => "public/javascripts/controls.js public/javascripts/dragdrop.js public/javascripts/effects.js public/javascripts/prototype.js", :commit => "-m 'Use jQuery'"
end

if SETTINGS['simple_navigation']
  generate "navigation_config"
  commit_all 'Use simple_navigation'
end

if SETTINGS['simple_form']
  generate "simple_form:install"
  commit_all 'Use simple_form'
end

if SETTINGS['nifty_layout']
  generate "nifty:layout", "-f", "--haml"
  commit_all 'Add nifty layout'
end

if SETTINGS['web_app_theme']['enabled']
  options = []
  options << "--engine=haml" if SETTINGS['haml']
  options << "--app-name='#{app_name}'"
  options << "--theme=#{SETTINGS['web_app_theme']['theme']}" unless SETTINGS['web_app_theme']['theme'] == ''

  generate "web_app_theme:theme", options

  commit_all 'Add web-app-theme layout'

  puts "You might need to tidy up web-app-theme a lot if you use other template functionality."
end

if SETTINGS['cappuccino']['enabled']
  run "capp gen #{app_name} -t #{SETTINGS['cappuccino']['cib_app'] ? "NibApplication" : "Application"}"
  run "mv #{app_name} Cappuccino"

  append_file '.gitignore', "Cappuccino/Build/*"

  commit_all 'Added Cappuccino'
end

if SETTINGS['static']
  get "#{TEMPLATES_PATH}/resources/static/static_controller.rb", "app/controllers/static_controller.rb"
  run "mkdir app/views/static"
  get "#{TEMPLATES_PATH}/resources/static/home.html.erb", "app/views/static/home.html.erb"

  route "root :to => 'static#home'"

  commit_all 'Static home page'
end
