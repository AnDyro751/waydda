require 'rails_helper'

RSpec.describe "Dashboard::Subscriptions", type: :request do
  let(:user) { create :user }
  before(:each) { sign_in user }

  context "#GETS" do
    before(:each) {
      user.places.create(attributes_for(:place))
    }
    describe "GET /dashboard/upgrade" do

      it 'should be render 200 status code' do
        get dashboard_upgrade_plan_path
        # puts "--------#{place}"
        expect(response).to have_http_status(200)
      end
      it 'should be render correct data' do
        get dashboard_upgrade_plan_path
        expect(response.body).to include("Precio simple sin engaños")
      end
    end

    describe "GET /dashboard/upgrade" do

      it 'GET /free - should be render correct template' do
        get dashboard_new_subscription_path("free")
        expect(response).to have_http_status(200)
        expect(response.body).to include("Ya cuentas con esta suscripción")
      end

      it "GET /premium - should be render correct template" do
        get dashboard_new_subscription_path("premium")
        expect(response).to have_http_status(200)
        expect(response.body).to include("Contratar premium")
      end
    end
  end


  context "#POST" do
    before(:each) {
      user.places.create(attributes_for(:place))
    }
    let(:params) do
      {
          place: {
              name: Faker::Company.name,
              address: Faker::Address.street_name
          }
      }
    end

    describe "POST /dashboard/upgrade/free when place plan is free" do
      #NOT IMPLEMENTED
      it 'should be redirect to dashboard/upgrade/free and show alert' do
        post dashboard_create_subscription_path("free"), params: params

      end
    end
  end

end
