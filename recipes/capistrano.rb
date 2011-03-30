gem "capistrano"
gem "capistrano-ext"

@strategies << lambda do
  run "bundle exec capify ."
  app_name = SETTINGS['capistrano']['app_name']
  server = SETTINGS['capistrano']['server']

  file 'config/deploy/staging.rb', <<-FILE
  set :rails_env, "staging"

  # Application Settings
  set :user,          "deploy"
  set :deploy_to,     "/var/rails/#{app_name}_staging"

  set(:current_branch) { `git branch`.match(/\* (\S+)\s/m)[1] || raise("Couldn't determine current branch") }
  set :branch, defer { current_branch }

  # Server Roles
  role :web, "#{server}"
  role :app, "#{server}"
  role :db,  "#{server}", :primary => true

  FILE

  file 'config/deploy/production.rb', <<-FILE

  set :rails_env, "production"

  # Application Settings
  set :user,          "deploy"
  set :deploy_to,     "/var/rails/#{app_name}_production"
  set :branch,        "master"

  # Server Roles
  role :web, "#{server}"
  role :app, "#{server}"
  role :db,  "#{server}", :primary => true

  FILE

  file 'config/deploy.rb', <<-FILE
  $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
  require 'rvm/capistrano'
  require 'bundler/capistrano'

  default_run_options[:pty] = true
  ssh_options[:forward_agent] = true

  set :application,   "#{app_name}"
  set :repository,    "#{SETTINGS['capistrano']['git_repo']}"
  set :scm,           :git
  set :deploy_via,    :export # :remote_cache
  set :use_sudo,      false
  set :keep_releases, 5

  set :rvm_ruby_string, "ruby-1.9.2"
  set :rvm_type, :user

  namespace :deploy do
    desc "Restart app"
    task :restart, :roles => :app do
      run "touch \#{release_path}/tmp/restart.txt"
    end
  end
  FILE

  commit_all 'Capistrano'
end
