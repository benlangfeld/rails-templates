gem 'factory_girl_rails', :group => :test

@strategies << lambda do
  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.fixture_replacement :factory_girl, :dir => '#{SETTINGS['rspec'] ? "spec/factories" : "test/factories"}'\n"
  end

  commit_all 'Use factory_girl'
end
