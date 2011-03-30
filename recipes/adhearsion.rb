gem "adhearsion"
gem "ahn-rails"

@strategies << lambda do
  run "bundle exec ahn create adhearsion"
  commit_all 'Add an Adhearsion app'
end
