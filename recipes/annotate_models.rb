gem "annotate-models", :group => :development

@stategies << lambda do
  run "bundle exec annotate"
  commit_all 'Annotate models'
end
