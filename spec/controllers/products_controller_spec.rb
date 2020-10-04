require 'rails_helper'
# require 'spec_helper'

RSpec.describe Dashboard::ProductsController, type: :controller do

  describe "GET /index" do
    let(:user) { FactoryBot.create(:user) }
    let(:place) { user.places.create(attributes_for :free_valid_place) }
    let(:product) { place.products.create(attributes_for :product) }

    it 'should be expect 1 place in user relations' do
      place = user.places.create(attributes_for :free_valid_place)
      expect(user.places.size).to eq(1)
    end


    it 'should be expect 1 product in pace' do
      place = user.places.create(attributes_for :free_valid_place)
      product = place.products.create(attributes_for :product)
      expect(place.products.size).to eq(1)
    end
    # it { expect(place.products.size).to eq(1) }

    context "no no auth" do
      before do
        get :show, params: {id: "demo"}
      end
      it { expect(response).to have_http_status(302) }
      it { expect(response.should).to redirect_to(new_user_session_path) }
    end

    context "with auth" do
      describe "When place is not created" do
        before(:each) do
          sign_in user
          get :show, params: {id: "demo"}
        end
        it { expect(response).to have_http_status(302) }
        it { expect(response.should).to redirect_to(new_dashboard_place_path) }
      end

      describe "place is created and product id is not valid" do
        before(:each) do
          place = user.places.create(attributes_for :free_valid_place)
          place.products.create(attributes_for :product)
          sign_in user
        end
        describe "if auth and place is created and product must not exist" do
          it 'should be return routing error' do
            expect {
              get :show, params: {id: "demo"}
            }.to raise_error(ActionController::RoutingError)
          end
        end

        describe "place is created and product is valid" do

          before(:each) do
            get :show, params: {id: product.id.to_s}
          end

          it { expect(response).to have_http_status(200) }
          it { expect(response.should).to render_template(:show) }

        end

      end
    end
  end

  context "POST /create" do

    describe "Un Auth" do
      before(:each) do
        post :index, params: {}
      end
      it { expect(response).to have_http_status(302) }
      it { expect(response.should).to redirect_to(new_user_session_path) }
    end

    context "With auth" do
      let(:user_with_place) { FactoryBot.create(:user_with_place) }
      before(:each) do
        sign_in user_with_place
      end

      it 'should be return ParameterMisging' do
        expect { post(:create, {}) }.to raise_error(ActionController::ParameterMissing)
      end

      describe "with valid params" do
        let(:valid_params) {
          {product: attributes_for(:product)}
        }

        before(:each) do
          post(:create, params: valid_params)
        end

        it { expect(response).to have_http_status(302) }
        it { expect(assigns(:product).errors.any?).to eq(false) }

        it { expect(response.should).to redirect_to(dashboard_product_path(assigns(:product))) }
      end

      describe "with invalid params" do
        let(:invalid_params) {
          {
              product: {
                  name: Faker::Name.name,
                  status: "active"
              }
          }
        }

        before(:each) do
          post(:create, params: invalid_params, :format => "js")
        end

        it { expect(response).to have_http_status(200) }
        it { expect(assigns(:product).errors.any?).to eq(true) }
        it { expect(assigns(:product).save).to eq(false) }
      end

    end
  end




end