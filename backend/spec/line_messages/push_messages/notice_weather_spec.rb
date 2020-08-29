require 'rails_helper'

RSpec.describe "notice_weather", type: :view do
  let(:file_name) { 'notice_weather' }
  let(:line_user) { build(:line_user_with_weather, silent_notice: false) }
  let(:weather)   { line_user.weather }
  let(:locals)    { { line_user: line_user, weather: weather } }

  subject { LineMessageCreator.create_from(file_name, **locals).first[:text] }

  it '日付が表示されていること' do
    is_expected.to match(%r{\d{1,2}/\d{1,2} \(.\)})
  end

  it '天気予報が表示されていること' do
    is_expected.to match(/\d{2}時 +･･･ +. +.+/)
  end
end
