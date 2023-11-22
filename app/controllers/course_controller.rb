class CourseController < ApplicationController
    before_action :current_instructor, only: [:new, :create]
    
    def index
        @courses = Course.all
    end
    def new
        @course = Course.new
    end

    def create
        puts "course = #{@course}"
        @course = @current_instructor.courses.build(course_params)
      
        if @course.save
        redirect_to courses_path, notice: 'Course created successfully'
        else
        flash[:notice] = 'Some error occurred, please try again.'
        render :new
        end
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
            else
              @current_instructor = nil
            end
          else
            @current_instructor = nil
          end
        else
          @current_instructor = nil
        end
        @current_instructor
    end
      
end
