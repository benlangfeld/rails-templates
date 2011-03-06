gem "cream"

@stategies << lambda do
  options = []
  options << "--roles #{SETTINGS['cream']['roles'].join ' '}" unless SETTINGS['cream']['roles'].nil? || SETTINGS['cream']['roles'].empty?
  options << "--strategy #{SETTINGS['cream']['strategy']}"

  generate "cream:full_config", options
  commit_all 'Use Cream (Devise, CanCan & Roles Generic) for authentication and authorization'
end
