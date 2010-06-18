class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def show
    if params[:id] == "current"
      id = current_user.id
    else
      id = params[:id]
    end
    @user = User.find(id)
  end
  
  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    if params[:id] == "current"
      id = current_user.id
    else
      id = params[:id]
    end
    @user = User.find(id)
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully closed account."
    redirect_to root_url
  end
end