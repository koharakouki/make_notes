require 'rails_helper'

RSpec.describe "RelationshipsController", type: :request do
	let(:user){ create(:user) }
  let(:other_user){ create(:other_user) }
  before do
    sign_in user
  end

  describe 'POST #create' do
		it 'リクエストが成功すること' do
			post relationships_url,
			params: { followed_id: other_user.id },
			xhr: true
			expect(response.status).to eq 200
		end

		it 'フォローが成功すること' do
			expect do
				post relationships_url,
			  params: { followed_id: other_user.id },
			  xhr: true
			end.to change { Relationship.all.count }.by(1)
		end
  end

  describe 'DELETE #destroy' do
  	let!(:relationship) { Relationship.create(follower_id: user.id, followed_id: other_user.id) }

  	it 'リクエストが成功すること' do
  		delete relationship_url(id: relationship.id), xhr: true
  		expect(response.status).to eq 200
  	end

  	it 'フォローが解除されること' do
  		expect do
	  		delete relationship_url(id: relationship.id), xhr: true
	  	end.to change  { Relationship.all.count }.by(-1)
	  end
  end
end
