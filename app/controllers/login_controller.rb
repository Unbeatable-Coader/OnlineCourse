class LoginController < ApplicationController

    def login
        
    end

    def verifyOTP
        mailOTP = SecureRandom.hex(3).upcase
        email = params[:email]
        password = params[:password]
        puts "password = #{password}"
        puts "email = #{email}"
        @user = User.find_by(email: email)
        puts "user = #{@user}"
      
        ::UserMailer.confirmation_email(email, mailOTP).deliver_now
      
        @stored_otp = mailOTP
        @user.password = BCrypt::Password.create(params[:password])

        if @user&.authenticate(@user.password)
          payload = { email: @user.email }
          token = JsonWebToken.encode(payload)
          session[:user_token] = token
          redirect_to loginConfirm_path
        else
          render json: { message: 'User not found or invalid password' }, status: :unauthorized
        end
      end
      
      def loginConfirm
      end
      
    
    def user_detail
        if @stored_otp == params[:otp]
            redirect_to user_detail_path
        end
        @current_user = current_user
        puts "Current User: #{@current_user.inspect}"
        token = session[:user_token]
        decoded_token = JsonWebToken.decode(token)
        puts "Decoded Token: #{decoded_token.inspect}"
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
