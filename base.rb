require 'yaml'

def execute_stategies
  @stategies.each { |stategy| stategy.call }
end

def recipe(name)
  File.join TEMPLATES_PATH, 'recipes', "#{name}.rb"
end

def y?(s)
  yes? "\n#{s} (y/n)", :yellow
end

def commit_all(message = '')
  git :add => ".", :commit => "-m '#{message}'"
end

TEMPLATES_PATH = "https://github.com/benlangfeld/rails-templates/raw/master"

CONFIG_FILE = File.join 'config', 'awesome_rails_config.yml'
get "#{TEMPLATES_PATH}/resources/awesome_templates_config.yml", "#{CONFIG_FILE}"
run "#{ENV['EDITOR']} #{CONFIG_FILE}"
SETTINGS = File.exists?(CONFIG_FILE) ? YAML.load_file(CONFIG_FILE) : {}

git :init

@stategies = []
@template_options = {}

apply recipe('rvm')
apply recipe('cleanup')
apply recipe('database')

run "cp config/environments/production.rb config/environments/staging.rb"

commit_all 'Base Rails app'

gem "nifty-generators", :group => :development

SETTINGS['enabled_recipes'].each { |recipe| apply recipe(recipe) }

run "bundle install --quiet"

commit_all 'Include a bunch of gems'

execute_stategies
