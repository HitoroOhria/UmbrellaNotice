require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  subject { response }

  describe 'GET /users/sign_in' do
    before do
      get new_user_session_path
    end

    it { is_expected.to have_http_status 200 }

    it { is_expected.to render_template :new }
  end
end
