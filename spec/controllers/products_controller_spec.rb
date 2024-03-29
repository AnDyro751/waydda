require 'rails_helper'
# require 'spec_helper'

RSpec.describe Dashboard::ProductsController, type: :controller do
  let(:user_with_place) { FactoryBot.create(:user_with_place) }

  describe "PRODUCTS" do
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
          place.products.create(attributes_for :product, place: user_with_place.places.last)
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


  context "GET #show" do
    let(:user_with_place) { FactoryBot.create(:user_with_place) }
    let(:product) { FactoryBot.create(:product, place: user_with_place.places.last) }

    describe "without session" do
      before(:each) do
        get :show, params: {id: "demo product"}
      end

      it { expect(response).to have_http_status(302) }
      it { expect(response.should).to redirect_to(new_user_session_path) }

    end

    describe "with session but product not exists" do
      before(:each) do
        sign_in user_with_place
      end

      it 'should be return action' do
        expect { get :show, params: {id: "demo product"} }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "with session and product exists" do
      before(:each) do
        sign_in user_with_place
        get :show, params: {id: product.id}
      end
      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template(:show) }
    end
  end

  context "GET /new" do
    describe "without session" do
      before(:each) do
        get :new
      end
      it { expect(response).to have_http_status(302) }
      it { expect(response.should).to redirect_to(new_user_session_path) }
    end

    describe "with session" do
      before(:each) do
        sign_in user_with_place
        get :new
      end

      it { expect(response).to have_http_status(200) }
      it { expect(response).to render_template(:new) }
      it { expect(response).not_to render_template(:create) }

    end
  end

  context "DESTROY /:id" do
    describe "without session" do
      before(:each) do
        delete :destroy, params: {id: "demo"}
      end

      it { expect(response).to have_http_status(302) }
      it { expect(response.should).to redirect_to(new_user_session_path) }
    end

    describe "with session but product is not created" do
      before(:each) do
        sign_in user_with_place
      end
      it 'should be return ActionController Routing error' do
        expect { delete :destroy, params: {id: "demo product"} }.to raise_error(ActionController::RoutingError)
      end
    end


    describe "with session and product exists" do
      let(:product) { FactoryBot.create(:product, place: user_with_place.places.last) }
      before(:each) do
        sign_in user_with_place
        delete :destroy, params: {id: product.id.to_s}
      end
      it 'should be redirect to dashboard_products_path' do
        expect(response.should).to redirect_to(dashboard_products_path)
      end
    end



  end
end