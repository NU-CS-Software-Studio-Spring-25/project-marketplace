class CoursesController < ApplicationController
  # Skip CSRF token verification for API requests
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all.includes(:instructors, :labels, :quarters, :prerequisites)
    
    respond_to do |format|
      format.html
      format.json { render json: @courses.as_json(include: {
        instructors: { only: [:id, :name, :email] },
        labels: { only: [:id, :name, :display_name] },
        quarters: { only: [:id, :name] },
        prerequisites: { only: [:id, :course_number, :name] }
      }) }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: @course.as_json(include: {
        instructors: { only: [:id, :name, :email] },
        labels: { only: [:id, :name, :display_name] },
        quarters: { only: [:id, :name] },
        prerequisites: { only: [:id, :course_number, :name] }
      }) }
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
    @instructors = Instructor.all
    @quarters = Quarter.all
    @labels = Label.all
    @available_prerequisites = Course.all
  end

  # GET /courses/1/edit
  def edit
    @instructors = Instructor.all
    @quarters = Quarter.all
    @labels = Label.all
    @available_prerequisites = Course.where.not(id: @course.id)
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        # Handle many-to-many associations
        update_associations

        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created }
      else
        @instructors = Instructor.all
        @quarters = Quarter.all
        @labels = Label.all
        @available_prerequisites = Course.all
        
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        # Handle many-to-many associations
        update_associations
        
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render json: @course }
      else
        @instructors = Instructor.all
        @quarters = Quarter.all
        @labels = Label.all
        @available_prerequisites = Course.where.not(id: @course.id)
        
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    begin
      # First, remove this course as a prerequisite for any other courses
      CoursePrerequisite.where(prerequisite_id: @course.id).destroy_all
      
      # Now it's safe to destroy the course
      @course.destroy
      
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
        format.json { head :no_content }
      end
    rescue => e
      respond_to do |format|
        format.html { redirect_to courses_url, alert: "Could not delete course: #{e.message}" }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  # GET /courses/search
  def search
    query = params[:q]
    label_ids = params[:label_ids]
    quarter_ids = params[:quarter_ids]
    instructor_ids = params[:instructor_ids]
    
    @courses = Course.all
    
    @courses = @courses.where("name ILIKE ? OR course_number ILIKE ? OR description ILIKE ?", 
                      "%#{query}%", "%#{query}%", "%#{query}%") if query.present?
    
    @courses = @courses.joins(:labels).where(labels: { id: label_ids }) if label_ids.present?
    @courses = @courses.joins(:quarters).where(quarters: { id: quarter_ids }) if quarter_ids.present?
    @courses = @courses.joins(:instructors).where(instructors: { id: instructor_ids }) if instructor_ids.present?
    
    @courses = @courses.includes(:instructors, :labels, :quarters, :prerequisites).distinct
    
    render json: @courses.as_json(include: {
      instructors: { only: [:id, :name, :email] },
      labels: { only: [:id, :name, :display_name] },
      quarters: { only: [:id, :name] },
      prerequisites: { only: [:id, :course_number, :name] }
    })
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.includes(:instructors, :labels, :quarters, :prerequisites).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:course_number, :name, :description)
    end
    
    # Update the many-to-many associations
    def update_associations
      # Handle instructors
      if params[:instructor_ids].present?
        @course.instructors = Instructor.where(id: params[:instructor_ids])
      end
      
      # Handle quarters
      if params[:quarter_ids].present?
        @course.quarters = Quarter.where(id: params[:quarter_ids])
      end
      
      # Handle labels
      if params[:label_ids].present?
        @course.labels = Label.where(id: params[:label_ids])
      end
      
      # Handle prerequisites
      if params[:prerequisite_ids].present?
        @course.prerequisites = Course.where(id: params[:prerequisite_ids])
      end
    end
end