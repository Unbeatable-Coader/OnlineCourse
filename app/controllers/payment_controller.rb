class PaymentController < ApplicationController
    def purchace
        @course = Course.find_by(params[:id])
        if @course.nil?
            flash[:error] = "Course not found"
            redirect_to index_path
        end
    end

    # def create_checkout_session
    #     @course = Course.find_by(params[:course_id])
    #     session[:course_id] = @course
    #     price_id = session[:course_id].id
    #     puts "course = #{@course}"
    #     puts "price id = #{price_id}"

    #     stripe_session = Stripe::Checkout::Session.create(
    #     payment_method_types: ['card'],
    #     mode: 'payment', 
    #     line_items: [{
    #         price: price_id,
    #         quantity: 1,
    #     }],
    #     success_url: payment_success_url,
    #     cancel_url: payment_cancel_url,
    #     )
    #     render json: { id: stripe_session.id }

    # end

    def create
        @course = Course.find_by(params[:course_id])
        token = params[:stripeToken]
        
        begin
            charge = Stripe::Charge.create(
            amount: @course.price * 100, # Convert to cents
            currency: 'inr',
            source: token,
            description: 'Course purchase'
            )
            # Handle successful payment (e.g., update user's course access)
            # Redirect to a success page or display a success message.
        rescue Stripe::CardError => e
            flash[:error] = e.message
            redirect_to course_path(@course)
        end
    end

    def payment_seccess

    end

    def payment_cancel

    end

end
