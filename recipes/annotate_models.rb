gem "annotate-models", :group => :development

stategies << lambda do
  run "annotate" # FIXME: reload shell first
  commit_all 'Annotate models'
end
