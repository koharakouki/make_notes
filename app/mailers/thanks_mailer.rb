class ThanksMailer < ApplicationMailer

  def welcome_mail(user)
    @user = user
    mail(from: 'make notes <makenotes2020@gmail.com>', to: @user.email, subject: 'ようこそmake notesへ')
  end

end
