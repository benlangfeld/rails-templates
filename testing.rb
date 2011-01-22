if yes?("Do you want to use RSpec for testing?")
  gem "rspec-rails", ">= 2.2.0"
  gem "rspec", ">= 2.3.0"
  run "bundle install"
  generate :rspec
end

if yes?("Do you want to use Mocha for mocking?")

end

if yes?("Do you want to use Cucumber for acceptance testing (with capybara)?")

end

if yes?("Do you want to use factory girl?")

end

if yes?("Do you want to use autotest (with mac stuff?)")

end
