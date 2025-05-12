class SessionsController < ApplicationController
  def new
  end

  def create
  end

  def destroy
  end

  def google_auth
    # logging the auth data to console so we can test
    Rails.logger.info request.env['omniauth.auth'].inspect
  
    # replace this when User model is done
    redirect_to root_path, alert: "Google login hit! Waiting on User model."
  end
end
