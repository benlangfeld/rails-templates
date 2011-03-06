gem 'rspec-rails',      '>= 2.0.0', :group => :test
gem 'database_cleaner',             :group => :test

@stategies << lambda do
  remove_file "test/"

  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.test_framework :rspec, :views => false\n"
  end

  generate "rspec:install"

  append_file("spec/spec_helper.rb") { "\nDatabaseCleaner.strategy = :truncation" }

  append_file(".rspec") { "\n--tty" }

  git :add => ".", :rm => "test/*", :commit => "-m 'Use rspec for testing'"
end
