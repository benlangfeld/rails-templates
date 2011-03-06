@stategies << lambda do
  run "capp gen #{app_name} -t #{SETTINGS['cappuccino']['cib_app'] ? "NibApplication" : "Application"}"
  run "mv #{app_name} Cappuccino"

  append_file '.gitignore', "Cappuccino/Build/*"

  commit_all 'Added Cappuccino'
end
