gem "simple-navigation"

@stategies << lambda do
  generate "navigation_config"
  commit_all 'Use simple_navigation'
end
