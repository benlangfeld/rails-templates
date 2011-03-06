puts "Using HAML by default..."
gem 'haml'
gem 'haml-rails'

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

bundle
commit_all 'Use HAML'

puts "Using jQuery..."
gem "jquery-rails"
bundle
generate "jquery:install", "--ui"
git :add => ".", :rm => "public/javascripts/controls.js public/javascripts/dragdrop.js public/javascripts/effects.js public/javascripts/prototype.js", :commit => "-m 'Use jQuery'"

puts "Using simple navigation..."
gem "simple-navigation"
bundle
generate "navigation_config"
commit_all 'Use simple_navigation'

puts "Using Kaminari for pagination..."
gem "kaminari"
bundle
commit_all 'Use Kaminari'

puts "Using simple_form..."
gem "simple_form"
bundle
generate "simple_form:install"
commit_all 'Use simple_form'

if @nifty_layout
  generate "nifty:layout", "-f", "--haml"
  commit_all 'Add nifty layout'
end

if @web_app_theme
  gem "web-app-theme", :git => "https://github.com/stevehodgkiss/web-app-theme.git", :group => :development
  bundle

  options = %w{--engine=haml}
  options << "--app-name='#{app_name}'"
  options << "--theme=#{@web_app_theme_theme}" unless @web_app_theme_theme == ''

  generate "web_app_theme:theme", options

  commit_all 'Add web-app-theme layout'

  puts "You might need to tidy up web-app-theme a lot if you use other template functionality."
end

if @cappuccino
  cap_template = @cib_app ? "NibApplication" : "Application"

  run "capp gen #{app_name} -t #{capp_template}"
  run "mv #{app_name} Cappuccino"

  run "echo 'Cappuccino/Build/*' >> .gitignore"

  commit_all 'Added Cappuccino'
end

puts "Adding a simple static home page..."
run "curl -s -L #{@templates_path}/resources/static/static_controller.rb > app/controllers/static_controller.rb"
run "mkdir app/views/static"
run "curl -s -L #{@templates_path}/resources/static/home.html.erb > app/views/static/home.html.erb"

route "root :to => 'static#home'"

commit_all 'Static home page'
