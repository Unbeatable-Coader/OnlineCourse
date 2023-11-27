class ReviewController < ApplicationController
    before_action :current_user, only: [:create]


    def new
    end
    def review

    end
    def create
        @course = Course.find_by(params[:course_id])
        @review = @course.reviews.new(review_params)
        @review.user = current_user
    
        if @review.save
          redirect_to course_reviews_path(@course), notice: 'Review was successfully submitted.'
        else
          render 'courses/show'  # Assuming you have a 'show' view for courses
        end
    end
    def course_reviews
        
    end

    def show
        @course = Course.find_by(params[:title])
        puts "course = #{@course}"
        @review = Review.all
    end

    private
    
    def review_params
        params.require(:review).permit(:rating, :comment, :course_id, :user_id)
    end
    
    def current_user
        token = session[:usertype]
        if token.present?
          user_info = JsonWebToken.decode(token)
          user_id = user_info[:email]
          if user_id.present?
            @current_user = User.find_by(email: user_id)
          else
            @current_user = nil
          end
        else
          @current_user = nil
        end
        @current_user
    end  
end
