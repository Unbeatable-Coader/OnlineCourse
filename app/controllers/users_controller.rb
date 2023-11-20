class UsersController < ApplicationController
    def new
        @user = User.new
    end


    
    def create
        mailOTP = SecureRandom.hex(3).upcase
        @user = User.new(user_params)
        @email = @user.email
        ::UserMailer.confirmation_email(@email, mailOTP).deliver_now
        if @user.valid?
            redirect_to confirmEmail_path
            user_entered_otp = params[:user][:otp]
            @stored_otp = session[:otp]
            puts "stored otp = #{@stored_otp}"
            puts "user enterd otp = #{user_entered_otp}"
            if @stored_otp == user_entered_otp
                @user.save
            else
                flash[:notice] = 'OTP is not valid'
            end

        else
            puts "Validation errors: #{@user.errors.full_messages}"
            flash[:alert] = @user.errors.full_messages
            render :new
        end    
    end

    def confirmEmail
    end

    private

    def user_params
        params.require(:user).permit(:name, :mobile, :email, :password_digest, :password_confirmation)
    end
end
