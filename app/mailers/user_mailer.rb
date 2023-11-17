class UserMailer < ApplicationMailer
    default from: 'rajeshpushpakar01@gmail.com'
    def confirmation_email(email, otp)
        puts "this is method from mailer"
        email = email
        puts "email = #{email}"
        @otp = otp
        mail(to: email, subject: 'Your OTP Code')
    end
end
