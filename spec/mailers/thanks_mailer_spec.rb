require "rails_helper"

RSpec.describe ThanksMailer, type: :mailer do
  describe "welcome_mail" do
    let!(:user) { create(:user) }
    let(:mail) { ThanksMailer.welcome_mail(user) }

    it "メールのヘッダー部分が正しいこと" do
      expect(mail.subject).to eq("ようこそmake notesへ")
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["makenotes2020@gmail.com"])
    end

    it "メールの本文が正しいこと" do
      expect(mail.body.encoded).to match("ご登録ありがとうございます！")
    end
  end
end
