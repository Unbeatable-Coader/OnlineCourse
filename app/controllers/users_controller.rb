class UsersController < ApplicationController
    def new
        @user = User.new
    end


    
    def create
        @user = User.new(user_params)
        session[:user] = @user
        @email = @user.email
        mailOTP = rand(1000..9999)
        puts "otsp = #{mailOTP}"
        session[:otp] = mailOTP
        
        ::UserMailer.confirmation_email(@email, mailOTP).deliver_now
        
        if @user.valid?
          redirect_to confirmEmail_path
        else
          puts "Validation errors: #{@user.errors.full_messages}"
          flash[:alert] = @user.errors.full_messages
          render :new
          return
        end  
    end

  
    def postEmail
      
    def confirmEmail

    end
      stored_otp = session[:otp]
      puts "stored otp = #{stored_otp}"
      user_entered_otp = params[:user_entered_otp]
      puts "user entered otp = #{user_entered_otp}"
      if session[:otp].to_s.strip == params[:user_entered_otp].to_s.strip
        puts "data save"
        user = User.new(session[:user])

        puts "user value = #{user}"
        user.save
        session.delete(:otp)
      else
        puts "data not saved"
        session.delete(:otp)
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :mobile, :email, :password_digest, :password_confirmation, :usertype)
    end

end
