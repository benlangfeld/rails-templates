@stategies << lambda do
  in_root do
    run "capp gen #{app_name} -t #{SETTINGS['cappuccino']['cib_app'] ? "NibApplication" : "Application"}"
    run "mv #{app_name} app/cappuccino"
  end

  append_file '.gitignore', "app/cappuccino/Build/*"

  commit_all 'Added Cappuccino'
end
