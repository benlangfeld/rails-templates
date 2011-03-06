gem 'mocha',                          :group => :test
gem 'rspec-rails-mocha', '~> 0.3.0',  :group => :test

stategies << lambda do
  append_file "spec/spec_helper.rb" do
    "Mocha::Configuration.warn_when(:stubbing_non_existent_method)\n" +
    "Mocha::Configuration.warn_when(:stubbing_non_public_method)"
  end

  gsub_file "spec/spec_helper.rb", /config\.mock_with :rspec/, "config.mock_with :mocha"
end
