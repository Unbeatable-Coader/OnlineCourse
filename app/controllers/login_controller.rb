class LoginController < ApplicationController

  before_action :current_user, only: [:user_detail]

    def login
        
    end

    def verifyOTP
      @email = params[:email]
      @user = User.find_by(email: @email)
      password = params[:password]
      mailOTP = rand(1000..9999)
      puts "otsp = #{mailOTP}"
      session[:otp] = mailOTP
      
      ::UserMailer.confirmation_email(@email, mailOTP).deliver_now


      @user.password = BCrypt::Password.create(params[:password])
      puts "password = #{password}"
      if @user&.authenticate(@user.password)
        
        redirect_to loginConfirm_path
      else
        puts "Validation errors: #{@user.errors.full_messages}"
        flash[:alert] = @user.errors.full_messages
        return
      end

    end
      
    def postlogin

    def loginConfirm

    end
      stored_otp = session[:otp]
      puts "stored otp = #{stored_otp}"
      user_entered_otp = params[:user_entered_otp]
      puts "user entered otp = #{user_entered_otp}"
      if session[:otp].to_s.strip == params[:user_entered_otp].to_s.strip
        puts "login save"

        @user = User.find_by(email: session[:email])
        if @user.usertype == "Instructor"     #Error
          
          redirect_to index2_path
        else
          redirect_to index_path
        end
        session.delete(:otp)
      else
        puts "data not saved"
        session.delete(:otp)
      end
    end
      
    
    def user_detail
      @current_user = @current_user
    end





    private
    def login_params 
        params.permit(:name, :password)
    end

    def current_user
        token = session[:user_token]
        if token.present?
          user_info = JsonWebToken.decode(token)
          user_id = user_info[:email]
          puts " user id = #{user_id}"
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
