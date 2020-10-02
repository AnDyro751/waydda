require 'rails_helper'
require 'spec_helper'

RSpec.describe Dashboard::AggregateCategoriesController, type: :request do
  describe "Un Auth" do
    before do
      get dashboard_product_aggregate_categories_path("11")
    end
    it "GET /index" do
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
    # it 'should be get sign in info' do
    #   follow_redirect!
    #   expect(page).to have_content("You need to sign in or sign up before continuing.")
    # end
  end
end