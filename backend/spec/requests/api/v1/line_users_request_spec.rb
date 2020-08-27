require 'rails_helper'

RSpec.describe "LineUsers", type: :request do
  # Define line_user.
  let(:success_response) {
    {
      'id' => line_user.id,
      'notice_time' => line_user.notice_time,
      'silent_notice' => line_user.silent_notice
    }
  }

  # Overwrite error_params to customize.
  let(:error_params) {
    {
      'error_params' => {
        'id' => id_error_messages # Define id_error_messages.
      }
    }
  }

  let(:error_response) {
    {
      'error' => true,
      **error_params
    }
  }

  subject { response }

  describe '#show' do
    it 'returns http success' do
      get '/line_users/show'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/line_users/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/line_users/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
