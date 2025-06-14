class EnrollmentsController < ApplicationController
  before_action :authenticate_user

  def create 
    @course = Course.find(params[:course_id])
    current_user.enrollments.create(course: @course)

    @course.labels.each do |label|
        current_user.labels << label unless current_user.labels.include?(label)
    end
    
    redirect_to swipes_path, notice: "Class was successfully added to your saved classes."
  end

  def index
    @enrollments = if current_user
      current_user.enrollments.includes(:course)
    else
      []
    end
  end

  def destroy
    @enrollment = current_user.enrollments.find(params[:id])
    course_labels = @enrollment.course.labels

    @enrollment.destroy
    course_labels.each do |label|
        current_user.labels.destroy(label) if current_user.labels.include?(label)
    end
    redirect_to saved_classes_path, notice: "Class was successfully removed from your saved classes."
  end

  private

  def authenticate_user
    redirect_to login_path, alert: "Please log in to view your saved classes." unless current_user
  end
end 