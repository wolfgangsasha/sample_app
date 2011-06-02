class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash[:error] = "Email and password combination is invalid."
      @title = "Sign in"
      render :new
    else
      flash[:success] = "Welcome!"
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
