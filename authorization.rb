if y?("Use Cream (Devise, CanCan & Roles Generic) for authentication and authorization?")
  gem "cream"
  run "bundle install"
  generate "cream:full_config", "--strategy #{ask "What role strategy should we use?"}", "--roles #{ask "What roles should we use (separate by spaces)?"}"
  git :add => ".", :commit => "-m 'Use Cream (Devise, CanCan & Roles Generic) for authentication and authorization'"
end

if y?("Automatically protect model attributes?")
  run "curl -s -L #{@templates_path}/resources/accessible_attributes.rb > config/initializers/accessible_attributes.rb"
  git :add => ".", :commit => "-m 'Automatically protect model attributes'"
end
