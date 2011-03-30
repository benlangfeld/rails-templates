@strategies << lambda do
  get "#{TEMPLATES_PATH}/resources/accessible_attributes.rb", "config/initializers/accessible_attributes.rb"
  commit_all 'Automatically protect model attributes'
end
