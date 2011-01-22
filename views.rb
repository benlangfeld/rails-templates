if yes?("Use HAML by default?")
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

  run "bundle install"

  git :add => ".", :commit => "-m 'Use HAML'"

  @use_haml = true
end

if yes?("Use jQuery?")
  gem "jquery-rails"
  run "bundle install"
  generate "jquery:install", "--ui"
  git :add => ".", :commit => "-m 'Use jQuery'"
end

if yes?("Use simple navigation?")

end

if yes?("Use will_paginate?")

end

if yes?("Use formtastic?")
  gem 'formtastic'
  run "bundle install"
  generate "formtastic:install"
  git :add => ".", :commit => "-m 'Use Formtastic'"
end

if yes?("Use simple_form?")

end

if yes?("Generate nifty layout?")
  generate "nifty:layout", "-f"
  git :add => ".", :commit => "-m 'Add nifty layout'"
end

if yes?("Generate web-app-theme layout?")
  gem "web-app-theme", :git => "https://github.com/stevehodgkiss/web-app-theme.git"
  run "bundle install"

  options = []

  theme = ask "Which theme would you like to use? (none for default) "
  options += ["--theme=#{theme}"] unless theme == ''

  app_name = ask "What is the name of the application?"
  options += ["--app-name=#{app_name}"] unless app_name == ''

  generate "web_app_theme:theme", options.flatten

  git :add => ".", :commit => "-m 'Add web-app-theme layout'"

  puts "You might need to tidy up web-app-theme a lot if you use other template functionality."
end

if yes?("Use Cappuccino?")
  apply "#{templates_path}/capponrails.rb"
end
