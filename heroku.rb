run 'rake heroku:create_config'
run 'rake all heroku:create heroku:remotes heroku:rack_env'

puts "You'll probably need to migrate your Heroku stack to bamboo-mri-1.9.2"

commit_all 'Use Heroku'
