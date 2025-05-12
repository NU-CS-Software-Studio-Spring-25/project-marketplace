class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    # Check if user exists and password is correct
    if user && user.password_digest == params[:password]
      # Store user id in session
      session[:user_id] = user.id
      redirect_to courses_path
    else
      # If authentication fails, show error message
      flash[:alert] = "invalid email or password"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end

  def google_auth
    # logging the auth data to console so we can test
    Rails.logger.info request.env['omniauth.auth'].inspect
  
    # replace this when User model is done
    redirect_to root_path, alert: "Google login hit! Waiting on User model."
  end
end
