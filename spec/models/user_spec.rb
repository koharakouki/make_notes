require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
  	let(:user) { build(:user) }

  	it 'フォームの項目が全て正しければ有効' do
  		expect(user).to be_valid
  	end

    context 'nameカラム' do
    	it '空欄でないこと' do
    		user.name = ''
    		expect(user).to be_invalid
    	end

    	it '100文字以下であること' do
    		user.name = 'a' * 101
    		expect(user).to be_invalid
    	end
    end

    context 'emailカラム' do
    	it '空欄でないこと' do
    		user.email = ''
    		expect(user).to be_invalid
    	end

    	it '255文字以下であること' do
    		user.email = "a" * 244 + "@example.com"
    		expect(user).to be_invalid
    	end

    	it '有効なメールアドレスであること(有効なアドレス検証)' do
    		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    		valid_addresses.each do |valid_address|
    			user.email = valid_address
    			expect(user).to be_valid
    		end
    	end

    	it '有効なメールアドレスであること(無効なアドレス検証)' do
    		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
		    invalid_addresses.each do |invalid_address|
		    	user.email = invalid_address
		    	expect(user).to be_invalid
		    end
		  end

		  it 'メールアドレスは一意であること' do
		  	duplicate_user = user.dup
		  	duplicate_user.email = user.email
		  	user.save
		  	expect(duplicate_user).to_not be_valid
		  end
		end

		context 'passwordカラム' do
			it '空欄でないこと' do
				user.password = ''
				expect(user).to_not be_valid
			end

			it '6文字以上であること' do
				user.password = 'a' * 5
				expect(user).to_not be_valid
			end

			it '128文字以下であること' do
				user.password = 'a' * 129
				expect(user).to_not be_valid
			end

			it 'パスワードと確認用パスワードが一致していること（有効なパスワード）' do
				user.password = 'testtest'
				user.password_confirmation = user.password
				expect(user).to be_valid
			end

			it 'パスワードと確認用パスワードが一致していること（無効なパスワード）' do
				user.password = 'testtest'
				user.password_confirmation = 'a' * 6
				expect(user).to_not be_valid
			end
		end

		context 'introduction' do
			it '100文字以下であること' do
				user.introduction = 'a' * 101
				expect(user).to_not be_valid
			end
		end
  end
end
