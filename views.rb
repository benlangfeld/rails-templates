if yes?("Do you want to use HAML by default?")

end

if yes?("Do you want to use jQuery?")

end

if yes?("Do you want to use simple navigation?")

end

if yes?("Do you want to use will_paginate?")

end

if yes?("Use formtastic?")
  gem 'formtastic'
  run "bundle install"
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
