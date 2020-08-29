require 'rails_helper'

RSpec.describe "Places", type: :request do
  let(:user) { create :user }

  describe "GET /places" do
    it "get place index" do
      get places_path
      expect(response).to have_http_status(200)
    end
  end

  describe "UNAUTH - GET /dashboard/places/new" do
    it 'should be redirect to sign in' do
      get new_dashboard_place_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_user_session_path)
      # expect(response).to render_template(:new)
    end
  end

  describe "AUTH - GET /dashboard/places/new" do
    before(:each) { sign_in user }
    it 'shoud be get to new place path' do
      get new_dashboard_place_path
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

end
