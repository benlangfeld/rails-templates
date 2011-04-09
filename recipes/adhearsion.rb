gem "ahn-rails"

@strategies << lambda do
  generate "ahn:app"
  generate "ahn:deployment", app_name
  commit_all 'Add an Adhearsion app'
end
