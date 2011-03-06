require 'yaml'

def y?(s)
  yes? "\n#{s} (y/n)", :yellow
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

def commit_all(message = '')
  git :add => ".", :commit => "-m '#{message}'"
end

TEMPLATES_PATH = "https://github.com/benlangfeld/rails-templates/raw/master"

CONFIG_FILE = File.join 'config', 'awesome_rails_config.yml'
run "curl -s -L #{TEMPLATES_PATH}/resources/awesome_templates_config.yml > #{CONFIG_FILE}"
run "#{ENV['EDITOR']} #{CONFIG_FILE}"
SETTINGS = File.exists?(CONFIG_FILE) ? YAML.load_file(CONFIG_FILE) : {}

if SETTINGS['github']['enabled']
  git :remote => "add github git@github.com:#{SETTINGS['github']['username']}/#{SETTINGS['github']['repo_name']}.git", :push => "github master"
end

git :init

apply "#{TEMPLATES_PATH}/rvm.rb"
apply "#{TEMPLATES_PATH}/cleanup.rb"

commit_all 'Base Rails app'

gem "nifty-generators", :group => :development
gem "has_scope" if SETTINGS['has_scope']
gem "simple_enum" if SETTINGS['simple_enum']
gem "andand" if SETTINGS['andand']
gem "jquery-rails" if SETTINGS['jquery']
gem "simple-navigation" if SETTINGS['simple_navigation']
gem "kaminari" if SETTINGS['kaminari']
gem "simple_form" if SETTINGS['simple_form']
gem "web-app-theme", :git => "https://github.com/stevehodgkiss/web-app-theme.git", :group => :development if SETTINGS['web_app_theme']['enabled']
gem 'factory_girl_rails', :group => :test if SETTINGS['factory_girl']
gem "cream" if SETTINGS['cream']['enabled']
gem "annotate-models", :group => :development if SETTINGS['annotate_models']

if SETTINGS['rspec']['enabled']
  gem 'rspec-rails',      '>= 2.0.0', :group => :test
  gem 'database_cleaner',             :group => :test

  if SETTINGS['rspec']['mocha']
    gem 'mocha',                          :group => :test
    gem 'rspec-rails-mocha', '~> 0.3.0',  :group => :test
  end
end

if SETTINGS['infinity_test']
  gem "ZenTest",        :group => :test
  gem "infinity_test",  :group => :test
end

if SETTINGS['cucumber']['enabled']
  gem 'cucumber-rails', :git => "git://github.com/aslakhellesoy/cucumber-rails.git",  :group => :test
  gem 'database_cleaner',                                                             :group => :test
  gem 'launchy',                                                                      :group => :test
  gem SETTINGS['cucumber']['backend'] || 'capybara',                                  :group => :test
end

if SETTINGS['haml']
  gem 'haml'
  gem 'haml-rails'
end

if SETTINGS['heroku']
  gem 'heroku', :group => :development
  gem 'heroku_san', :group => :development
end

if SETTINGS['adhearsion']
  gem "adhearsion"
  gem "ahn-rails"
end

run "bundle install --quiet"
commit_all 'Include a bunch of gems'

say "Setting up the staging environment"
run "cp config/environments/production.rb config/environments/staging.rb"
commit_all 'Add staging environment'

apply "#{TEMPLATES_PATH}/database.rb"
apply "#{TEMPLATES_PATH}/testing.rb"
apply "#{TEMPLATES_PATH}/authorization.rb"
apply "#{TEMPLATES_PATH}/views.rb"

if SETTINGS['annotate_models']
  run "annotate" # FIXME: reload shell first
  commit_all 'Annotate models'
end

if SETTINGS['adhearsion']
  run "ahn create adhearsion" # FIXME: reload shell first
  commit_all 'Add an Adhearsion app'
end

if SETTINGS['heroku']
  apply "#{TEMPLATES_PATH}/heroku.rb"
end
