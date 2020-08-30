require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /users/sign_in" do

    it 'should be render correct template' do
      get new_user_session_path
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

end
