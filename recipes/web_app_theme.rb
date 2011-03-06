gem "web-app-theme", :git => "https://github.com/stevehodgkiss/web-app-theme.git", :group => :development

@stategies << lambda do
  options = []
  options << "--engine=haml" if SETTINGS['enabled_recipes'].include? 'haml'
  options << "--app-name='#{app_name}'"
  options << "--theme=#{SETTINGS['web_app_theme']['theme']}" unless SETTINGS['web_app_theme']['theme'] == ''

  generate "web_app_theme:theme", options

  commit_all 'Add web-app-theme layout'

  puts "You might need to tidy up web-app-theme a lot if you use other template functionality."
end
