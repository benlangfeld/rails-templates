if yes?("Use RSpec for testing?")
  gem "rspec-rails", ">= 2.2.0"
  gem "rspec", ">= 2.3.0"
  run "bundle install"
  generate :rspec
end

if yes?("Use Mocha for mocking?")

end

if yes?("Use Cucumber for acceptance testing (with capybara)?")

end

if yes?("Use factory girl?")

end

if yes?("Use autotest (with mac stuff?)")

end
