class HomeController < ApplicationController
  def redirect_root
    if current_user
      redirect_to courses_path
    else
      redirect_to login_path
    end
  end
end
