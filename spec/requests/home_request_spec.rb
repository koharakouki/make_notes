require 'rails_helper'

RSpec.describe "HomeController", type: :request do

  describe "GET #top" do
    it "トップページにアクセスできること" do
      get root_path
      expect(response.status).to eq 200
    end
  end

end