require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/users/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/users/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destory" do
    it "returns http success" do
      get "/api/v1/users/destory"
      expect(response).to have_http_status(:success)
    end
  end

end
