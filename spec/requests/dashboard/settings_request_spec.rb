require 'rails_helper'

RSpec.describe "Dashboard::Settings", type: :request do

  describe "GET /general" do
    it "returns http success" do
      get "/dashboard/settings/general"
      expect(response).to have_http_status(:success)
    end
  end

end
