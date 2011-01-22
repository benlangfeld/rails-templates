if yes?("Use declarative_authorization?")
  apply "#{@templates_path}/declarative_authorization.rb"
end

if yes?("Use Cream (Devise, CanCan & Roles Generic) for authentication and authorization?")

end

if yes?("Automatically protect model attributes?")

end
