class UserMailer < ApplicationMailer

	def everymonth_mail(user)
    mail(from: 'make notes <makenotes2020@gmail.com>', to: user.email, subject: "make notesです")
  end
end
