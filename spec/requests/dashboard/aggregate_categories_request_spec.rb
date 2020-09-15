require 'rails_helper'

RSpec.describe "Dashboard::AggregateCategories", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/dashboard/aggregate_categories/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/dashboard/aggregate_categories/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
