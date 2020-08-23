require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let!(:user) { create(:user) }

  subject { response }

  describe '#create' do
    let(:email) { Faker::Internet.email }

    before do
      post api_v1_users_path, params: { email: email }
    end

    describe '正常時' do
      it { is_expected.to have_http_status 201 }

      it '作成したリソースのshowアクションへのLocationヘッダーを返すこと' do
        encoded_email = User.find_by(email: email).encoded_email
        expect(response.headers['Location']).to eq api_v1_user_url(encoded_email)
      end

      it '作成したUserモデルの属性JSONを返すこと' do
        user = User.find_by(email: email)
        expect(JSON.parse(response.body)).to eq user.response_attributes
      end
    end

    describe '異常時' do
      context 'emailの表記が正しくないとき' do
        let(:email) { 'Invalid_email_address' }

        it { is_expected.to have_http_status 422 }

        it 'エラーメッセージを返すこと' do
          expect(response.body).to eq 'Invalid email address.'
        end
      end

      context '既に存在しているemailのとき' do
        before do
          post api_v1_users_path, params: { email: email }
        end

        it { is_expected.to have_http_status 422 }

        it 'エラーメッセージを返すこと' do
          expect(response.body).to eq 'Email address already exist.'
        end
      end
    end
  end

  describe '#show' do
    let!(:user) { create(:user) }
    let(:email) { user.email }

    before do
      get api_v1_user_path(email)
    end

    describe '正常時' do
      it { is_expected.to have_http_status 200 }

      it 'emailに対応したUserモデル属性のJSONを返すこと' do
        expect(JSON.parse(response.body)).to eq user.response_attributes
      end
    end

    describe '異常時' do
      let(:email) { Faker::Internet.email }

      context '存在しないemailを指定したとき' do
        it { is_expected.to have_http_status 404 }

        it 'エラーメッセージを返すこと' do
          expect(response.body).to eq "Not fond '#{email}' user."
        end
      end
    end
  end

  describe '#update' do
    let!(:user) { create(:user) }
    let(:email) { user.email }
    let(:new_email) { Faker::Internet.email }

    before do
      put api_v1_user_path(email), params: { new_email: new_email }
    end

    describe '正常時' do
      it { is_expected.to have_http_status 200 }

      it '更新後のUserモデルの属性のJSONを返すこと' do
        new_user = User.find_by(email: new_email)
        expect(JSON.parse(response.body)).to eq new_user.response_attributes
      end
    end

    describe '異常時' do
      context '存在しないemailを指定したとき' do
        let(:email) { Faker::Internet.email }

        it { is_expected.to have_http_status 404 }

        it 'エラーメッセージを返すこと' do
          expect(response.body).to eq "Not fond '#{email}' user."
        end
      end

      context 'new_emailの表記が正しくないとき' do
        let(:new_email) { 'Invalid_email_address' }

        it { is_expected.to have_http_status 422 }

        it 'エラーメッセージを返すこと' do
          expect(response.body).to eq 'Invalid email address.'
        end
      end
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }
    let(:email) { user.email }

    before do
      delete api_v1_user_path(email)
    end

    describe '正常時' do
      it { is_expected.to have_http_status 204 }

      it 'レスポンスボディは空であること' do
        expect(response.body).to be_empty
      end
    end

    describe '異常時' do
      context '存在しないemailを指定したとき' do
        let(:email) { Faker::Internet.email }

        it { is_expected.to have_http_status 404 }

        it 'エラーメッセージを返すこと' do
          expect(response.body).to eq "Not fond '#{email}' user."
        end
      end
    end
  end
end
