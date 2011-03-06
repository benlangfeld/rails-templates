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

def bundle
  puts "Running bundle install..."
  run "bundle install --quiet"
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

gem "nifty-generators", :group => :development

bundle

commit_all 'Base Rails app (with nifty generators)'

say "Setting up the staging environment"
run "cp config/environments/production.rb config/environments/staging.rb"
commit_all 'Add staging environment'

apply "#{TEMPLATES_PATH}/database.rb"
apply "#{TEMPLATES_PATH}/testing.rb"
apply "#{TEMPLATES_PATH}/authorization.rb"
apply "#{TEMPLATES_PATH}/views.rb"

if SETTINGS['has_scope']
  gem "has_scope"
  bundle
  commit_all 'Use has_scope'
end

if SETTINGS['simple_enum']
  gem "simple_enum"
  bundle
  commit_all 'Use simple_enum'
end

if SETTINGS['andand']
  gem "andand"
  bundle
  commit_all 'Use andand'
end

if SETTINGS['annotate_models']
  gem "annotate-models", :group => :development
  bundle
  run "annotate" # FIXME: reload shell first
  commit_all 'Annotate models'
end

if SETTINGS['adhearsion']
  gem "adhearsion"
  gem "ahn-rails"
  bundle
  run "ahn create adhearsion" # FIXME: reload shell first
  commit_all 'Add an Adhearsion app'
end

if SETTINGS['heroku']
  apply "#{TEMPLATES_PATH}/heroku.rb"
end
