if yes?("Do you want to use Cappuccino?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/capponrails.rb"
end

if yes?("Use declarative_authorization for simple authorization?")
  apply "http://github.com/benlangfeld/rails-templates/raw/master/declarative_authorization.rb"
end

if yes?("Do you want to use Cream (Devise, CanCan & Roles Generic) for authentication and authorization?")

end

if yes?("Do you want to automatically protect model attributes?")

end
