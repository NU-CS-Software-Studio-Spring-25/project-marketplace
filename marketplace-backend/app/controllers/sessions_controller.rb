class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new]
  ALLOWED_DOMAINS = %w[u.northwestern.edu].freeze
  
  def new
  end

  def create 
    user_info = request.env['omniauth.auth']
    email = user_info['info']['email']
    domain = email&.split('@')&.last

    unless ALLOWED_DOMAINS.include?(domain)
      redirect_to login_path,
        alert: "Please log in with your #{ALLOWED_DOMAINS.join(' / ')} account."
      return
    end

    user = User.find_or_create_by(uid: user_info['uid'], provider: user_info['provider']) do |u|
      u.name = user_info['info']['name']
      u.email = email
      u.profile_picture_url = user_info['info']['image']
    end

    # Update profile picture if it has changed
    if user.profile_picture_url != user_info['info']['image']
      user.update(profile_picture_url: user_info['info']['image'])
    end

    session[:user_id] = user.id
    redirect_to root_path, notice: "Signed in as #{user.name}"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out."
  end
  
  def google_auth
    # This method is intentionally empty
    # OmniAuth middleware will intercept the request and redirect to Google
    # The actual authentication happens in the create method after callback
  end
end
