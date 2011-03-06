if SETTINGS['cream']['enabled']
  gem "cream"
  bundle

  options = []
  options << "--roles #{SETTINGS['cream']['roles'].join ' '}" unless SETTINGS['cream']['roles'].nil? || SETTINGS['cream']['roles'].empty?
  options << "--strategy #{SETTINGS['cream']['strategy']}"

  generate "cream:full_config", options
  commit_all 'Use Cream (Devise, CanCan & Roles Generic) for authentication and authorization'
end

if SETTINGS['auto_protect_model_attributes']
  run "curl -s -L #{TEMPLATES_PATH}/resources/accessible_attributes.rb > config/initializers/accessible_attributes.rb"
  commit_all 'Automatically protect model attributes'
end
