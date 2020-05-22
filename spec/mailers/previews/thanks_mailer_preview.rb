# Preview all emails at http://localhost:3000/rails/mailers/thanks_mailer
class ThanksMailerPreview < ActionMailer::Preview
  def welcome_mail
    ThanksMailer.welcome_mail
  end
end
