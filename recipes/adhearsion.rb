gem "adhearsion"
gem "ahn-rails"

@stategies << lambda do
  run "ahn create adhearsion" # FIXME: reload shell first
  commit_all 'Add an Adhearsion app'
end
