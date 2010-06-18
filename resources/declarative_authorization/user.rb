class User < ActiveRecord::Base
  acts_as_authentic
  
  def role_symbols
    rolesymbols = []
    rolesymbols += [:member]
    rolesymbols
  end
end