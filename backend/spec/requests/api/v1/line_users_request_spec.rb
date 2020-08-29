require 'rails_helper'

RSpec.describe "Api::V1::LineUsers", type: :request do
  let(:error_msg)    { ERROR_MSG[:LINE_USER] }
  let(:update_attrs) { UPDATE_ATTRS[:LINE_USER] }

  # Define line_user.
  let(:success_response) {
    {
      'id' => line_user.id,
      'notice_time' => line_user.notice_time,
      'silent_notice' => line_user.silent_notice
    }
  }

  # Define user if used.
  let(:user_response) {
    {
      'id' => user.id,
      'email' => user.email
    }
  }

  let(:error_response) {
    {
      'error' => true,
      'error_params' => error_params # Define error_params.
    }
  }

  subject { response }

  describe '#show' do
    let!(:line_user) { create(:line_user) }
    let(:id)         { line_user.id }
    let(:embed)      { nil }

    before do
      get api_v1_line_user_path(id), params: { embed: embed }
    end

    describe '正常系' do
      context 'embedがnilのとき' do
        it { is_expected.to have_http_status 200 }

        it 'idに対応したLineLineUserモデル属性のJSONを返すこと' do
          expect(JSON.parse(response.body)).to eq success_response
        end
      end

      # TODO: Why response.body['user'] = nil ?
      # context 'embedがuserのとき' do
      #   let(:embed) { 'user' }
      #   let!(:user) { create(:user, line_user: line_user) }
      #
      #   it { is_expected.to have_http_status 200 }
      #
      #   it 'UserとLineUserの属性のJSONを返すこと' do
      #     success_response['user'] = user_response
      #     expect(JSON.parse(response.body)).to eq success_response
      #   end
      # end
    end

    describe '異常系' do
      context '存在しないidを指定したとき' do
        let(:id)           { 10**8 }
        let(:error_params) {
          { 'id' => [error_msg[:ID][:NOT_FOUND][id]] }
        }

        it { is_expected.to have_http_status 404 }

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

        it { is_expected.to have_http_status 200 }

        it '更新後のLineUserモデルの属性のJSONを返すこと' do
          line_user.notice_time = notice_time
          expect(JSON.parse(response.body)).to eq success_response
        end
      end

      describe 'silent_notice' do
        let(:silent_notice) { 'false' }

        it { is_expected.to have_http_status 200 }

        it '更新後のLineUserモデルの属性のJSONを返すこと' do
          line_user.silent_notice = false
          expect(JSON.parse(response.body)).to eq success_response
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

          it { is_expected.to have_http_status 400 }

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

          it { is_expected.to have_http_status 400 }

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

          it { is_expected.to have_http_status 400 }

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
      it { is_expected.to have_http_status 204 }

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

        it { is_expected.to have_http_status 404 }

        it 'エラーレスポンスを返すこと' do
          expect(JSON.parse(response.body)).to eq error_response
        end
      end
    end
  end
end
