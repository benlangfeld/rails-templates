if yes?("Do you want to use RSpec for testing?")
  run "echo 'gem \"rspec-rails\", \">= 2.0.0.beta.8\"' >> Gemfile"
  run "echo 'gem \"rspec\", \">= 2.0.0.beta.8\"' >> Gemfile"
  run "bundle install"
  generate :rspec
end

generate :nifty:layout

git :init

run "echo 'TODO add readme content' > README"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/database.yml.example"
run "rm public/images/rails.png"
run "rm public/index.html"

file ".gitignore", <<-END
.bundle
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

git :add => ".", :commit => "-m 'Base Rails app'"