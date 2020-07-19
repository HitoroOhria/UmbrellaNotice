require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  subject { response }

  describe 'GET /' do
    before do
      get root_path
    end

    it { is_expected.to have_http_status 200 }

    it { is_expected.to render_template :home }
  end

  describe 'GET /about' do
    before do
      get about_path
    end

    it { is_expected.to have_http_status 200 }

    it { is_expected.to render_template :about }
  end

  describe 'GET /policy' do
    before do
      get policy_path
    end

    it { is_expected.to have_http_status 200 }

    it { is_expected.to render_template :policy }
  end

  describe 'GET /terms' do
    before do
      get terms_path
    end

    it { is_expected.to have_http_status 200 }

    it { is_expected.to render_template :terms }
  end
end
