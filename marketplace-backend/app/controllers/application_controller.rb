class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  helper_method :current_user
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def redirect_if_authenticated
    redirect_to saved_classes_path if current_user
  end

  def authenticate_user
    redirect_to login_path, alert: "Please log in to view your saved classes." unless current_user
  end
end
