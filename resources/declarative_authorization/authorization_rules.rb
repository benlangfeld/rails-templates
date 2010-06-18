authorization do
  role :guest do
    has_permission_on :static, :to => :home
    has_permission_on [:user_sessions, :users], :to => :start
  end
end

privileges do
  privilege :view do
    includes :index, :show
  end
  
  privilege :start do
    includes :new, :create
  end
  
  privilege :manage do
    includes :edit, :update, :destroy
  end
  
  privilege :all do
    includes :index, :show, :new, :create, :edit, :update, :destroy
  end
end