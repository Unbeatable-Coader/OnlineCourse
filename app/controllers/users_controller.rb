class UsersController < ApplicationController
    def new
        @user = User.new
    end


    mailOTP = SecureRandom.hex(3).upcase
    puts "mailOTP = #{mailOTP}"

    def create
        @user = User.new(user_params)
        @email = @user.email
        if @user.valid?
            mailOTP = SecureRandom.hex(3).upcase
            if mailOTP.present?
                redirect_to confirmEmail_path
            end

            # UserMailer.with(user: @user).confirmation_email.deliver_now
            ::UserMailer.confirmation_email(@email, mailOTP).deliver_now
        else
            puts "Validation errors: #{@user.errors.full_messages}"
            flash[:alert] = @user.errors.full_messages
            render :new
        end    
    end

    # def confirmEmail
    #     puts "otp = #{@otp}"
    #     if @otp == params[:otp]
            # @user.save
    #       redirect_to root_path, notice: 'Your email has been confirmed. You can now log in.'
    #     else
    #       redirect_to root_path, alert: 'Invalid OTP. Please try again.'
    #     end
    # end

    private

    def user_params
        params.require(:user).permit(:name, :mobile, :email, :password_digest, :password_confirmation)
    end
end
