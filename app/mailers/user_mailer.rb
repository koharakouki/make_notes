class UserMailer < ApplicationMailer
  def everymonth_mail
  	logger.debug "aaa"
    mail(from: 'make notes <makenotes2020@gmail.com>', bcc: User.pluck(:email), subject: "make notesです")
  end
end
