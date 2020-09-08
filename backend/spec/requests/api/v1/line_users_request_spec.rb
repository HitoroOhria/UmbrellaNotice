require 'rails_helper'

RSpec.describe "Api::V1::LineUsers", type: :request do
  let(:error_msg)    { ERROR_MSG[:LINE_USER] }
  let(:update_attrs) { UPDATE_ATTRS[:LINE_USER] }
  let(:success_json) { { 'success' => true } }

  # Define line_user.
  let(:line_user_data) {
    {
      'id' => line_user.id.to_s,
      'type' => 'lineUser',
      'attributes' => {
        'noticeTime' => line_user.notice_time,
        'silentNotice' => line_user.silent_notice
      }
    }
  }

  let(:error_response) {
    {
      'error' => true,
      'error_params' => error_params # Define error_params.
    }
  }

  subject { JSON.parse(response.body)['data']&.slice("id", "type", "attributes") }

  describe '#show' do
    let!(:line_user) { create(:line_user) }
    let(:id)         { line_user.id }
    let(:embed)      { nil }

    before do
      get api_v1_line_user_path(id), params: { embed: embed }
    end

    describe '正常系' do
      context 'embedがnilのとき' do
        it "HTTPステータスコード200を返すこと" do
          expect(response).to have_http_status 200
        end

        it 'idに対応したLineLineUserモデル属性のJSONを返すこと' do
          is_expected.to eq line_user_data
        end
      end
    end

    describe '異常系' do
      context '存在しないidを指定したとき' do
        let(:id)           { 10**8 }
        let(:error_params) {
          { 'id' => [error_msg[:ID][:NOT_FOUND][id]] }
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
    let!(:line_user)    { create(:line_user) }
    let(:id)            { line_user.id }
    let(:notice_time)   { nil }
    let(:silent_notice) { nil }

    before do
      put api_v1_line_user_path(id),
          params: {
            notice_time: notice_time,
            silent_notice: silent_notice
          }
    end

    describe '正常系' do
      describe 'notice_time' do
        let(:notice_time) { '19:00' }

        it "HTTPステータスコード200を返すこと" do
          expect(response).to have_http_status 200
        end

        it '更新後のLineUserモデルの属性のJSONを返すこと' do
          line_user.notice_time = notice_time
          is_expected.to eq line_user_data
        end
      end

      describe 'silent_notice' do
        let(:silent_notice) { 'false' }

        it "HTTPステータスコード200を返すこと" do
          expect(response).to have_http_status 200
        end

        it '更新後のLineUserモデルの属性のJSONを返すこと' do
          line_user.silent_notice = false
          is_expected.to eq line_user_data
        end
      end
    end

    describe '異常系' do
      describe 'attributes' do
        context '更新する属性がすべてnilのとき' do
          let(:error_params) {
            {
              'attributes' => [error_msg[:ATTRIBUTES][:UPDATE_BLANK][update_attrs]]
            }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end

      describe 'notice_time' do
        context 'notice_timeの表記が正しくないとき' do
          let(:notice_time)  { 'Invalid_notice_time' }
          let(:error_params) {
            { 'notice_time' => [error_msg[:NOTICE_TIME][:VALIDATE]] }
          }

          it "HTTPステータスコード400を返すこと" do
            expect(response).to have_http_status 400
          end

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end

      describe 'silent_notice' do
        context 'silent_noticeが"true"か"false"以外のとき' do
          let(:silent_notice) { 'nil' }
          let(:error_params)  {
            { 'silent_notice' => [error_msg[:SILENT_NOTICE][:VALIDATE]] }
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
    let!(:line_user) { create(:line_user) }
    let(:id)         { line_user.id }

    before do
      delete api_v1_line_user_path(id)
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
      context '存在しないidを指定したとき' do
        let(:id)           { 10**8 }
        let(:error_params) {
          { 'id' => [error_msg[:ID][:NOT_FOUND][id]] }
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
