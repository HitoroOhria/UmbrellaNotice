require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:error_msg)    { ERROR_MSG[:USER] }
  let(:update_attrs) { UPDATE_ATTRS[:USER] }
  let(:success_json) { { 'success' => true } }

  # Define user.
  let(:user_data) {
    {
      'id' => user.id.to_s,
      'type' => 'user',
      'attributes' => {
        'email' => user.email
      }
    }
  }

  # Define email_error_params.
  let(:error_response) {
    {
      'error' => true,
      'error_params' => error_params
    }
  }

  subject { JSON.parse(response.body)['data']&.slice("id", "type", "attributes") }

  describe '#create' do
    let(:email) { Faker::Internet.email }

    before do
      post api_v1_users_path, params: { email: email }
    end

    describe '正常系' do
      it "HTTPステータスコード201を返すこと" do
        expect(response).to have_http_status 201
      end

      it '作成したリソースのshowアクションへのLocationヘッダーを返すこと' do
        encoded_email = User.find_by(email: email).encoded_email
        expect(response.headers['Location']).to eq api_v1_user_url(encoded_email)
      end

      it '成功メッセージを返すこと' do
        expect(JSON.parse(response.body)).to eq success_json
      end

      it 'Userを1つ作成すること' do
        expect {
          post api_v1_users_path, params: { email: Faker::Internet.email }
        }.to change(User, :count).by(1)
      end
    end

    describe '異常系' do
      context 'emailがnilのとき' do
        let(:email)        { nil }
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:VALIDATE], "can't be blank"] }
        }

        it "HTTPステータスコード400を返すこと" do
          expect(response).to have_http_status 400
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end

      context 'emailの表記が正しくないとき' do
        let(:email)        { 'Invalid_email_address' }
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:VALIDATE]] }
        }

        it "HTTPステータスコード400返すこと" do
          expect(response).to have_http_status 400
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end

      context '既に存在しているemailのとき' do
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:EXIST]] }
        }

        before do
          post api_v1_users_path, params: { email: email }
        end

        it "HTTPステータスコード422を返すこと" do
          expect(response).to have_http_status 422
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end
    end
  end

  describe '#show' do
    let!(:user)      { create(:user) }
    let!(:line_user) { nil }
    let!(:weather)   { nil }
    let(:email)      { user.email }
    let(:embed)      { nil }

    before do
      get api_v1_user_path(email), params: { embed: embed }
    end

    describe '正常系' do
      context 'embedがnilのとき' do
        it "HTTPステータスコード200を返すこと" do
          expect(response).to have_http_status 200
        end

        it 'emailに対応したUserモデル属性のJSONを返すこと' do
          is_expected.to eq user_data
        end
      end
    end

    describe '異常系' do
      context 'emailの表記が正しくないとき' do
        let(:email)        { 'Invalid_email_address' }
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:VALIDATE]] }
        }

        it "HTTPステータスコード400を返すこと" do
          expect(response).to have_http_status 400
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end

      context '存在しないemailを指定したとき' do
        let(:email)        { Faker::Internet.email }
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:NOT_FOUND][email]] }
        }

        it "HTTPステータスコード404を返すこと" do
          expect(response).to have_http_status 404
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end
    end
  end

  describe '#update' do
    let!(:user)     { create(:user) }
    let(:email)     { user.email }
    let(:new_email) { Faker::Internet.email }

    before do
      put api_v1_user_path(email), params: { new_email: new_email }
    end

    describe '正常系' do
      it "HTTPステータスコード200を返すこと" do
        expect(response).to have_http_status 200
      end

      it '更新後のUserモデルの属性のJSONを返すこと' do
        user = User.find_by!(email: new_email)
        user_data['attributes']['email'] = user.email

        is_expected.to eq user_data
      end
    end

    describe '異常系' do
      describe 'email' do
        context 'emailの表記が正しくないとき' do
          let(:email)        { 'Invalid_email_address' }
          let(:error_params) {
            { 'email' => [error_msg[:EMAIL][:VALIDATE]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context '存在しないemailを指定したとき' do
          let(:email)        { Faker::Internet.email }
          let(:error_params) {
            { 'email' => [error_msg[:EMAIL][:NOT_FOUND][email]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end

      describe 'new_email' do
        context 'new_emailがnilのとき' do
          let(:new_email)    { nil }
          let(:error_params) {
            { 'attributes' => [error_msg[:ATTRIBUTES][:UPDATE_BLANK][update_attrs]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'new_emailの表記が正しくないとき' do
          let(:new_email)    { 'Invalid_email_address' }
          let(:error_params) {
            { 'new_email' => [error_msg[:NEW_EMAIL][:VALIDATE]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
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

    describe '正常系' do
      it "HTTPステータスコード204を返すこと" do
        expect(response).to have_http_status 204
      end

      it 'レスポンスボディは空であること' do
        expect(response.body).to be_empty
      end
    end

    describe '異常系' do
      context 'emailの表記が正しくないとき' do
        let(:email)        { 'Invalid_email_address' }
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:VALIDATE]] }
        }

        it "HTTPステータスコード400を返すこと" do
          expect(response).to have_http_status 400
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end

      context '存在しないemailを指定したとき' do
        let(:email)        { Faker::Internet.email }
        let(:error_params) {
          { 'email' => [error_msg[:EMAIL][:NOT_FOUND][email]] }
        }

        it "HTTPステータスコード404を返すこと" do
          expect(response).to have_http_status 404
        end

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end
    end
  end

  describe '#relate_line_user' do
    let!(:user)         { create(:user) }
    let!(:line_user)    { create(:line_user) }
    let(:email)         { user.email }
    let(:inherit_token) { line_user.inherit_token }

    before do
      post relate_line_user_api_v1_user_path(email),
           params: {
             inherit_token: inherit_token
           }
    end

    describe '正常系' do
      it "HTTPステータスコード200を返すこと" do
        expect(response).to have_http_status 200
      end

      it '成功メッセージを返すこと' do
        expect(JSON.parse(response.body)).to eq success_json
      end

      it 'line_userとuserが関連付けられていること' do
        expect(line_user.reload.user).to eq user
      end
    end

    describe '異常系' do
      describe 'email' do
        context 'emailの表記が正しくないとき' do
          let(:email)        { 'Invalid_email_address' }
          let(:error_params) {
            { 'email' => [error_msg[:EMAIL][:VALIDATE]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context '存在しないemailを指定したとき' do
          let(:email)        { Faker::Internet.email }
          let(:error_params) {
            { 'email' => [error_msg[:EMAIL][:NOT_FOUND][email]] }
          }

          it "HTTPステータスコード404を返すこと" do
            expect(response).to have_http_status 404
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end

      describe 'inherit_token' do
        context 'inherit_tokenの長さが24文字以外のとき' do
          let(:inherit_token) { nil }
          let(:error_params)  {
            { 'inherit_token' => [error_msg[:INHERIT_TOKEN][:NOT_FOUND][inherit_token]] }
          }

          it "HTTPステータスコード404を返すこと" do
            expect(response).to have_http_status 404
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'inherit_tokenの長さが24文字以外のとき' do
          let(:inherit_token) { 'invalid_token' }
          let(:error_params)  {
            { 'inherit_token' => [error_msg[:INHERIT_TOKEN][:VALIDATE]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context '存在しないinherit_tokenを指定したとき' do
          let(:inherit_token) { 'a' * 24 }
          let(:error_params)  {
            { 'inherit_token' => [error_msg[:INHERIT_TOKEN][:NOT_FOUND][inherit_token]] }
          }

          it "HTTPステータスコード404を返すこと" do
            expect(response).to have_http_status 404
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end
    end
  end

  describe '#release_line_user' do
    let!(:user)      { create(:user) }
    let!(:line_user) { create(:line_user, user: user) }
    let(:email)      { user.email }

    before do
      post release_line_user_api_v1_user_path(email)
    end

    describe '正常系' do
      it "HTTPステータスコード200を返すこと" do
        expect(response).to have_http_status 200
      end

      it '成功メッセージを返すこと' do
        expect(JSON.parse(response.body)).to eq success_json
      end

      it 'line_userとuserが関連付けられていないこと' do
        expect(line_user.reload.user).to eq nil
      end
    end

    describe '異常系' do
      describe 'email' do
        context 'emailの表記が正しくないとき' do
          let(:email)        { 'Invalid_email_address' }
          let(:error_params) {
            { 'email' => [error_msg[:EMAIL][:VALIDATE]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context '存在しないemailを指定したとき' do
          let(:email)        { Faker::Internet.email }
          let(:error_params) {
            { 'email' => [error_msg[:EMAIL][:NOT_FOUND][email]] }
          }

          it "HTTPステータスコード404を返すこと" do
            expect(response).to have_http_status 404
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end
    end
  end
end
