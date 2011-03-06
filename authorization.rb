if @cream
  gem "cream"
  bundle

  options = []
  options << "--roles #{@cream_roles}" if @cream_roles.present?

  @cream_strategy = "admin_flag" if @cream_strategy.empty?
  options << "--strategy #{@cream_strategy}"

  generate "cream:full_config", options
  commit_all 'Use Cream (Devise, CanCan & Roles Generic) for authentication and authorization'
end

puts "Automatically protecting model attributes..."
run "curl -s -L #{@templates_path}/resources/accessible_attributes.rb > config/initializers/accessible_attributes.rb"
commit_all 'Automatically protect model attributes'
