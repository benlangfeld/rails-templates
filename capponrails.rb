if yes?("Use a CIB based app?")
  arguments = "-t NibApplication"
else
  arguments = "-t Application"
end

appName = ask "What's the name of the app?"

run "capp gen #{appName} #{arguments}"
run "mv #{appName} Cappuccino"

run "echo 'Cappuccino/Build/*' >> .gitignore"

git :add => "Cappuccino", :commit => "-m 'Added Cappuccino'"