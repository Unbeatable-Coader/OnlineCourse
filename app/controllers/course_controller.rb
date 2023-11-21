class CourseController < ApplicationController

    before_action :current_user, only: [:new, :create]
    
    def index
        @course = Course.all
    end
    def new
        @course = Course.new
    end

    def create
        @course = @current_instructor.courses.build(course_params)
        if @course.save
            redirect_to courses_path, notice: 'courses created successfull'
        else
            if @current_instructor.present?

                flash[:notice] = 'you are not a authorised user'
                render :new
            end
            flash[:notice] = 'Some error is occur please try again.'
            render :new
        end

    end

    def uploadFile

    end

    private

    def course_params
        params.require(:course).permit(:title, :description, :price, :video, :document)
    end

    def current_user
        token = session[:user_token]
        if token.present?
          user_info = JsonWebToken.decode(token)
          user_id = user_info[:email]
          puts " user id = #{user_id}"
          if user_id.present?
            user = User.find_by(email: user_id)
            if user.usertype == "Instructor"
                @current_instructor =  user

            else
                @current_student = user
            end
          else
            @current_user = nil
          end
        else
          @current_user = nil
        end
        @current_user
    end
end
