class CourseController < ApplicationController
    before_action :current_instructor, only: [:new, :create]
    before_action :current_instructor, only: [:enroll]


    def index
      @courses = Course.all
    end

    def new
      @course = Course.new
    end

    def create
      puts "course params = #{course_params}"
      puts "instructor = #{@current_instructor.email}"
      
      @course = @current_instructor.courses.build(course_params)
      
      puts "course = #{@course.title}"
      
      if @course.save
        redirect_to courses_path, notice: 'Course created successfully'
      else
        error_messages = @course.errors.full_messages
        error_messages.each do |message|
          puts "error = #{message}"
        end
        
        
        render :new 
      end
    end
    
      

    def enroll
      course_id = params[:id]

      @course = Course.find_by(id: course_id)

      if @course.present?
        @enroll = @current_user.enrollments.build(course: @course)
        @check = @current_user.enrollments.find_by(course: @course&.id)

        if !@check.present?
          if @enroll.save
            flash[:success] = "You have enrolled successfully in course"
            redirect_to courses_path
          else
            flash[:warning] = "Course enrollment failed for this course"
            redirect_to courses_path
          end
        else
          flash[:warning] = "You are already enrolled in this course"
          redirect_to courses_path
        end
      else
        flash[:warning] = "Course Not Found "
        redirect_to courses_path
      end 
    end
    
    
    def enrollCourse
    end
    

    def uploadFile

    end

    private
    
    def course_params
        params.require(:course).permit(:title, :description, :price, :video, :document, :user_id)
    end

    def current_instructor
        token = session[:usertype]
        puts "token = #{token}"
        if token.present?
          user_info = JsonWebToken.decode(token)
          user_id = user_info[:email]
          puts "user id = #{user_id}"
          if user_id.present?
            user = User.find_by(email: user_id)
            puts "user = #{user}"
            if user.usertype == "Instructor"
              @current_instructor = user 
            elsif user.usertype == "Student"
              @current_user = user
            end
          else
            @current_instructor = nil
          end
        else
          @current_instructor = nil
        end
        
    end
      
end
