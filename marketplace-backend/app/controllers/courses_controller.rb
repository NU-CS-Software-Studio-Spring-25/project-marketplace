class CoursesController < ApplicationController
  # Skip CSRF token verification for API requests
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:swipes]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.order(:course_number).includes(:instructors, :labels, :quarters, :prerequisites)
    
    # Apply search query if present
    if params[:q].present?
      @courses = @courses.where("name ILIKE ? OR course_number ILIKE ? OR description ILIKE ?", 
                    "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%")
    end
    
    # Apply filters if present, ignoring blank values
    if params[:label_ids].present?
      label_ids = Array(params[:label_ids]).reject(&:blank?)
      @courses = @courses.joins(:labels).where(labels: { id: label_ids }) if label_ids.any?
    end
    if params[:quarter_ids].present?
      quarter_ids = Array(params[:quarter_ids]).reject(&:blank?)
      @courses = @courses.joins(:quarters).where(quarters: { id: quarter_ids }) if quarter_ids.any?
    end
    if params[:instructor_ids].present?
      instructor_ids = Array(params[:instructor_ids]).reject(&:blank?)
      @courses = @courses.joins(:instructors).where(instructors: { id: instructor_ids }) if instructor_ids.any?
    end
    
    # Ensure we get distinct results when using joins
    @courses = @courses.distinct
    
    # For PDF, get all courses without pagination
    if request.format.pdf?
      @all_courses = @courses
    else
      # Apply pagination only for HTML requests
      @courses = @courses.page(params[:page]).per(params[:per_page] || 12)
    end
    
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "course_catalog_#{Date.current.strftime('%Y_%m_%d')}",
               layout: 'pdf',
               page_size: 'A4',
               margin: { top: 15, bottom: 15, left: 10, right: 10 },
               encoding: 'UTF-8',
               show_as_html: params[:debug].present?
      end
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

  # GET /swipes
  def swipes
    saved_ids = current_user.enrollments.pluck(:course_id)
    user_labels = current_user.labels.pluck(:id)
    if user_labels.any?
            prioritized_courses = Course.joins(:labels)
                 .where(labels: { id: user_labels })
                 .where.not(id: saved_ids)
                 .select('courses.*')
                 .distinct


            @courses = Course.from(prioritized_courses, :courses)
                 .includes(:instructors, :labels, :quarters, :prerequisites)
                 .order(Arel.sql('RANDOM()'))
                 .limit(20)

    else
        @courses = Course.where.not(id: saved_ids)
                    .includes(:instructors, :labels, :quarters, :prerequisites)
                    .order(Arel.sql('RANDOM()'))
                    .limit(20) 
    end 
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