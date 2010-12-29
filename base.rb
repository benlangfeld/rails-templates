def y?(s)
  yes? "\n#{s} (y/n)"
end

def maybe_update_file(options = {})
  old_contents = File.read options[:file]
  look_for = options[:after] || options[:before] # but not both!
  return if options[:unless_present] && old_contents =~ options[:unless_present]

  if options[:action].nil? || y?("Should I #{options[:action]} to #{options[:file]}?")
    File.open(options[:file], "w") do |file|
      file.print old_contents.sub(look_for, "#{look_for}\n#{options[:content]}") if options[:after]
      file.print old_contents.sub(look_for, "#{options[:content]}\n#{look_for}") if options[:before]
    end

    if old_contents.scan(look_for).length > 1
      puts "\nNOTE: #{options[:file]} may not have been updated correctly, so please take a look at it.\n"
    end
  end
end

gem "nifty-generators"

git :init

run "echo 'TODO add readme content' > README"
run "find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;"
run "cp config/database.yml config/database.yml.example"
run "rm public/images/rails.png"
run "rm public/index.html"

run "echo 'config/database.yml' >> .gitignore"

git :add => ".", :commit => "-m 'Base Rails app'"

run "bundle install"

if yes?("Generate nifty layout?")
  generate "nifty:layout", "-f"
  git :add => ".", :commit => "-m 'Add nifty layout'"
end

if yes?("Generate web-app-theme layout?")
  gem "web-app-theme", :git => "http://github.com/stevehodgkiss/web-app-theme.git"
  run "bundle install"

  options = []

  theme = ask "Which theme would you like to use? (none for default) "
  options += ["--theme=#{theme}"] unless theme == ''

  app_name = ask "What is the name of the application?"
  options += ["--app-name=#{app_name}"] unless app_name == ''

  generate "web_app_theme:theme", options.flatten

  git :add => ".", :commit => "-m 'Add web-app-theme layout'"
end

if yes?("Add a simple static home page?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/static.rb"
end

# if yes?("Use ActiveRecord session store?")
#   rake('db:sessions:create')
#   initializer 'session_store.rb', <<-FILE
#     ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
#     ActionController::Base.session_store = :active_record_store
#   FILE
#
# end

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

rake "db:migrate"