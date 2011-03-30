gem "simple_form"

@strategies << lambda do
  generate "simple_form:install"
  commit_all 'Use simple_form'
end
