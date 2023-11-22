class LoginController < ApplicationController

  before_action :current_user, only: [:user_detail]

    def login
        
    end

    def verifyOTP
      @email = params[:email]
      @user = User.find_by(email: @email)
      session[:user] = @user

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
      user_entered_otp = params[:user_entered_otp]
      if session[:otp].to_s.strip == params[:user_entered_otp].to_s.strip 

        user = session[:user]

        @user = User.new(user)

        userEmail = @user.email

        payload = {email: userEmail }
        puts "useremail = #{userEmail}"
        encoded_payload = JsonWebToken.encode(payload)



        session[:usertype] = encoded_payload

        puts "usertype = #{session[:usertype]}"
        if  @user.usertype == "Instructor"

        # session[:usertype] = User.find_by(email: @email)
        # utype = session[:usertype]
        # if utype == "Instructor"   
          puts "index2 path"
          redirect_to index2_path
        else
          puts "index1 path"
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
