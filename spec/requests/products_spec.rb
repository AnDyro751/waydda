require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create :user }

  describe "GET /products" do
    before(:each) { sign_in user }
    it 'should be render all products' do
      get dashboard_products_path
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

end
