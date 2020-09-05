require 'rails_helper'

RSpec.describe "Products", type: :request do

  let(:user) { create :user }

  context "#UNAUTH" do
    describe "GET /products" do
      it 'should be redirect to sign in page' do
        get dashboard_products_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "#AUTH" do
    before(:each) { sign_in user }
    describe "no place created- GET /products" do
      it 'not should be render all products' do
        get dashboard_products_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_dashboard_place_path)
        follow_redirect!
        expect(response).to render_template(:new)
        expect(response.body).to include("Crear empresa")
      end
    end

    describe "#AUTH" do
      describe "GET /products when place is not created" do
        it 'should be render form for create new place' do
          get dashboard_products_path
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(new_dashboard_place_path)
          follow_redirect!
          expect(response).to render_template(:new)
          expect(response.body).to include("Crear empresa")
        end
      end
      describe "GET /products when place is created" do
        it 'should be render all products' do
          user.places.build(attributes_for(:place))
          get dashboard_products_path
          expect(response).to have_http_status(200)
          expect(response).to render_template(:index)
        end
      end
    end
  end

end
