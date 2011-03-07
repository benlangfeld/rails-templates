gem "adhearsion"
gem "ahn-rails"

@stategies << lambda do
  run "bundle exec ahn create adhearsion"
  commit_all 'Add an Adhearsion app'
end
