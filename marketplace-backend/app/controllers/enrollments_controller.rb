class EnrollmentsController < ApplicationController
  before_action :authenticate_user

  def index
    @enrollments = if current_user
      current_user.enrollments.includes(:course)
    else
      []
    end
  end

  def destroy
    @enrollment = current_user.enrollments.find(params[:id])
    @enrollment.destroy
    redirect_to saved_classes_path, notice: "Class was successfully removed from your saved classes."
  end

  private

  def authenticate_user
    redirect_to login_path, alert: "Please log in to view your saved classes." unless current_user
  end
end 