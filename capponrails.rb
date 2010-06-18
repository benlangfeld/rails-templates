arguments = ""
if yes?("Do you want to use a CIB based app?")
  arguments = "-t NibApplication"
else
  arguments = "-t Application"
end

appName = ask("What's the name of the app?")

cappCommand = "capp gen" + appName + " " + arguments
run cappCommand
run "mv " + appName + " Cappuccino"

run "echo 'Cappuccino/Build/*' >> .gitignore"

git :add => "Cappuccino", :commit => "-m 'Added Cappuccino'"