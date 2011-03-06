gem 'heroku', :group => :development
gem 'heroku_san', :group => :development
bundle

run 'rake heroku:create_config'
run 'rake all heroku:create heroku:remotes heroku:rack_env deploy'

puts "You'll probably need to migrate your Heroku stack to bamboo-mri-1.9.2"

commit_all 'Use Heroku'
