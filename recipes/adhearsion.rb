gem "ahn-rails"

@strategies << lambda do
  run "bundle exec rails g ahn:app"
  commit_all 'Add an Adhearsion app'
end
