require 'rails_helper'
# require 'spec_helper'

RSpec.describe Dashboard::ProductsController, type: :controller do
  describe "Un Auth" do
    before do
      get :show, params: {id: "demo"}
    end
    it "GET /index" do
      expect(response).to have_http_status(302)
      expect(response.should).to redirect_to(new_user_session_path)
        # expect(response).to have_http_status(:success)
        # expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
    # it 'should be get sign in info' do
    #   follow_redirect!
    #   expect(page).to have_content("You need to sign in or sign up before continuing.")
    # end
  end
end