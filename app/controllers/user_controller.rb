class UserController < ApplicationController
  skip_before_filter :redirect_if_anoymous, :only => [:new, :create]
  before_filter :redirect_unless_admin, :only => [:new, :create, :index, :delete]
  before_filter :error_unless_authorized, :only => [:edit, :update]


  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1 (route not implemented)
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to(root_url, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    attributes = params[:user]

    #Always delete is_admin attibute unless user is admin
    attributes.delete(:is_admin) unless session[:is_admin]

    if @user.update_attributes(attributes)
      redirect_to(user_index_url, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(user_index_url, :notice => "User was successfully removed")
  end

end
