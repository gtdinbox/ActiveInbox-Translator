class UserSessionController < ApplicationController
  skip_before_filter :redirect_if_anoymous, :only => [:new, :create]




  # Renders the login form.
  #
  def new
    if session[:user_id]
      redirect_to root_url, :notice => 'You are logged in already!'
    else
      @user=User.new
    end
  end

  def create
    user = User.authenticate(params[:user][:email], params[:user][:password])
    if user
      session[:user_id] = user.id
      session[:is_admin] = user.is_admin
      redirect_to root_url :notice => "Logged in"
    else
      redirect_to login_url, :notice => "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url :notice => 'Logged out'
  end
end

