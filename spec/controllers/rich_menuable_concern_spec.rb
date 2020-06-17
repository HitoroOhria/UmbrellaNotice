require 'rails_helper'

RSpec.describe "RichMenuables", type: :controller do
  controller ApplicationController do
    include Lineable
    include RichMenuable

    def reply(*file_names, **locals)
      messages = file_names.map { |file_name| read_message(file_name, **locals) }
      messages.join('')
    end
  end

  let(:fixture_dir)    { 'spec/fixtures' }

  let(:weather_dir)    { 'weather_api' }
  let(:weather_name)   { 'fixed_clear_forecast.json' }
  let(:weather_file)   { File.open(Rails.root + fixture_dir + weather_dir + weather_name) }
  let!(:json_forecast) { JSON.parse(weather_file.read, symbolize_names: true) }

  let(:event_dir)      { 'line_api/rich_menus' }
  let(:event_name)     { 'postback_request.json' }
  let(:event_file)     { File.open(Rails.root + fixture_dir + event_dir + event_name) }
  let!(:event)         { JSON.parse(event_file.read)['events'][0] }

  let!(:line_user)     { create(:line_user_with_weather, silent_notice: true) }
  let!(:weather)       { line_user.weather }

  before do
    allow(weather).to receive(:forecast).and_return(json_forecast)
  end

  describe '#reply_weather_forecast' do
    subject { controller.reply_weather_forecast(event, line_user) }

    it '天気予報通知のメッセージを返すこと' do
      is_expected.to include '今日は雨は降りません！'
    end
  end

  describe '#notice_time_setting' do
    let(:event_name) { 'time_select_request.json' }

    subject(:notice_time_setting) { controller.notice_time_setting(event, line_user) }

    it 'line_users.notice_time を更新すること' do
      notice_time_setting
      expect(line_user.reload.notice_time).to eq '07:18'
    end

    it '設定後の通知時間のを返すこと' do
      is_expected.to include '07:18'
    end
  end

  describe '#toggle_silent_notice' do
    let!(:old_silent_notice) { line_user.silent_notice }

    subject(:toggle_silent_notice) { controller.toggle_silent_notice(event, line_user) }

    it 'line_user.silent_noticeの値を反転させること' do
      toggle_silent_notice
      expect(line_user.reload.silent_notice).to eq !old_silent_notice
    end

    it 'サイレント通知の設定完了メッセージを返すこと' do
      is_expected.to include 'サイレント通知の設定が完了しました！'
    end
  end

  describe '#location_resetting' do
    subject(:location_resetting) { controller.location_resetting(event, line_user) }

    it 'line_userのlocating_atを更新すること' do
      location_resetting
      expect(line_user.reload.locating_from).to be_present
    end

    it '位置情報の再設定中メッセージを返すこと' do
      is_expected.to include '位置情報の再設定を行います！'
    end
  end

  describe '#issue_serial_number' do
    subject { controller.issue_serial_number(event, line_user) }

    it 'アカウント登録時のトークンを返すこと' do
      is_expected.to include line_user.inherit_token
    end
  end

  describe '#profile_page' do
    subject { controller.profile_page(event, line_user) }

    context '関するユーザーが存在しない時' do
      it 'アカウント登録ページのURLを返すこと' do
        is_expected.to include 'https://www.umbrellanotice.work/users/sign_up'
      end
    end
  end
end
