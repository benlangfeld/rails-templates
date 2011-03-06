if SETTINGS['rspec']['enabled']
  remove_file "test/"

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.test_framework :rspec, :views => false\n"
  end

  generate "rspec:install"

  if SETTINGS['rspec']['mocha']
    append_file "spec/spec_helper.rb" do
      "Mocha::Configuration.warn_when(:stubbing_non_existent_method)\n" +
      "Mocha::Configuration.warn_when(:stubbing_non_public_method)"
    end

    gsub_file "spec/spec_helper.rb", /config\.mock_with :rspec/, "config.mock_with :mocha"
  end

  append_file("spec/spec_helper.rb") { "\nDatabaseCleaner.strategy = :truncation" }

  append_file(".rspec") { "\n--tty" }

  git :add => ".", :rm => "test/*", :commit => "-m 'Use rspec for testing'"
end

if SETTINGS['factory_girl']
  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.fixture_replacement :factory_girl, :dir => '#{SETTINGS['rspec'] ? "spec/factories" : "test/factories"}'\n"
  end

  commit_all 'Use factory_girl'
end

commit_all 'Use infinity_test' if SETTINGS['infinity_test']

if SETTINGS['cucumber']['enabled']
  options = ["--#{SETTINGS['cucumber']['backend'] || 'capybara'}"]
  options << "--rspec" if SETTINGS['rspec']['enabled']

  generate "cucumber:install", options

  get "#{TEMPLATES_PATH}/resources/factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb" if SETTINGS['factory_girl']

  commit_all 'Use cucumber for acceptance testing'
end
