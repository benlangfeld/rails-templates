if yes?("Use rspec and rspec-rails?", :yellow)
  @use_rspec = true

  remove_file "test/"

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.test_framework :rspec, :views => false\n"
  end

  gem 'rspec',            '>= 2.0.0', :group => :test
  gem 'rspec-rails',      '>= 2.0.0', :group => :test
  gem 'database_cleaner',             :group => :test

  if yes?("Install mocha?", :yellow)
    gem 'mocha', :group => :test

    append_file "spec/spec_helper.rb" do
      "Mocha::Configuration.warn_when(:stubbing_non_existent_method)\n" +
      "Mocha::Configuration.warn_when(:stubbing_non_public_method)"
    end

    gsub_file "spec/spec_helper.rb", /config\.mock_with :rspec/, "config.mock_with :mocha"
  end

  append_file "spec/spec_helper.rb" do
    "\nDatabaseCleaner.strategy = :truncation"
  end

  run "bundle install"

  generate "rspec:install"

  git :add => ".", :commit => "-m 'Use rspec for testing'"
end

if yes?("Install factory_girl?", :yellow)
  gem 'factory_girl_rails', :group => :test

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.fixture_replacement :factory_girl, :dir => '#{@use_rspec ? "spec/factories" : "test/factories"}'\n"
  end

  run "bundle install"

  git :add => ".", :commit => "-m 'Use factory_girl'"
end

if yes?("Use autotest (with mac stuff?)")

end

if yes?("Use Cucumber for acceptance testing (with capybara)?")
  gem 'database_cleaner', :group => :test
  gem 'cucumber',         :group => :test
  gem 'cucumber-rails',   :group => :test
  gem 'launchy',          :group => :test

  if yes?("Use Capybara instead of Webrat?", :yellow)
    gem 'capybara', :group => :test
    @use_capybara = true
  else
    gem 'webrat', :group => :test
  end

  run "bundle install"

  arguments = [].tap do |arguments|
    arguments << "--webrat"    if @use_capybara.nil?
    arguments << "--capybara"  if @use_capybara.present?
    arguments << "--rspec"     if yes?("Use with rspec?", :yellow)
  end

  generate "cucumber:install #{arguments.join(" ")}"

  get "#{@templates_path}/resources/cucumber.yml", "config/cucumber.yml", :force => true

  git :add => ".", :commit => "-m 'Use cucumber for acceptance testing'"
end
