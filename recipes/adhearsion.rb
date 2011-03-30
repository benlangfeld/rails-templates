gem "adhearsion"
gem "ahn-rails"

@stategies << lambda do
  inside "app" do
    run "bundle exec ahn create adhearsion"
  end
  commit_all 'Add an Adhearsion app'
end
