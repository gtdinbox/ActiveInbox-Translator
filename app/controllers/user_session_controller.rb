class UserSessionController < ApplicationController
  skip_before_filter :redirect_if_anoymous, :only => [:new, :create]

  def new
    @user=User.new
  end

  def create
    user = User.authenticate(params[:user][:email], params[:user][:password])
    if user
      session[:user_id] = user.id
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

