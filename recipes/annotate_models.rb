gem "annotate-models", :group => :development

@strategies << lambda do
  run "bundle exec annotate"
  commit_all 'Annotate models'
end
