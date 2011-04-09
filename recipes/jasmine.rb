gem 'jasmine', :group => :test

@strategies << lambda do
  run "bundle exec jasmine init"

  commit_all 'Use Jasmine for testing JS'
end
