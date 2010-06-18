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

maybe_update_file :file => ".gitignore", :action => "add 'Cappuccino/Build/*'", :unless_present => /Cappuccino/, :content => "Cappuccino/Build/*"

git :add => "Cappuccino", :commit => "-m 'Added Cappuccino'"