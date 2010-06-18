generate "nifty:layout"

git :init

run "echo 'TODO add readme content' > README"
run "find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;"
run "cp config/database.yml config/database.yml.example"
run "rm public/images/rails.png"
run "rm public/index.html"

run "echo 'config/database.yml' >> .gitignore"

git :add => ".", :commit => "-m 'Base Rails app'"

run "bundle install"

if yes?("Add a simple static home page?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/static.rb"
end

if yes?("Use ActiveRecord session store?")
  rake('db:sessions:create')
  initializer 'session_store.rb', <<-FILE
    ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
    ActionController::Base.session_store = :active_record_store
  FILE
    
end

if yes?("Use formtastic?")
  gem 'formtastic'
  run "bundle install"
end

if yes?("Do you want to use RSpec for testing?")
  gem "rspec-rails", ">= 2.0.0.beta.8"
  gem "rspec", ">= 2.0.0.beta.8"
  run "bundle install"
  generate :rspec
end

if yes?("Do you want to use Cappuccino?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/capponrails.rb"
end

if yes?("Use authlogic for simple authentication?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/authlogic.rb"
end

if yes?("Use declarative_authorization for simple authorization?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/declarative_authorization.rb"
end

if yes?("Host on GitHub?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/github.rb"
end