require 'rails_helper'

RSpec.describe "lib/line_messages", type: :view do
  describe '*.txt' do
    let(:file_paths)      { Dir[Rails.root + "lib/line_messages/*.txt"] }
    let(:txt_file_paths)  { file_paths.select { |file_path| File.extname(file_path) == '.txt' } }
    let(:file_names)      { txt_file_paths.map { |file_path| file_path.slice(/line_messages\/(.+).txt/, 1) } }

    it 'file の内容を文字列として取得できること' do
      file_names.each do |file_name|
        expect(ApplicationController.new.read_message(file_name).class).to eq String
      end
    end
  end

  describe 'notice_weather.txt.erb' do
    let(:weather)   { build(:weather) }
    let(:line_user) { weather.line_user }
    let(:locals)    { [[:line_user, line_user], [:weather, weather]] }

    let(:dir_path)      { 'spec/fixtures/weather_api' }
    let(:file_name)     { 'fixed_clear_forecast.json' }
    let(:api_response)  { File.open(Rails.root + dir_path + file_name) }
    let(:json_forecast) { JSON.parse(api_response.read, symbolize_names: true) }

    before do
      allow(weather).to receive(:forecast).and_return(json_forecast)
    end

    subject do
      ApplicationController.new.read_message('notice_weather', line_user: line_user, weather: weather)
    end

    it '日付が表示されていること' do
      is_expected.to match(%r{\d{1,2}/\d{1,2} \(.\)})
    end

    it '天気予報が表示されていること' do
      is_expected.to match(/\d{2}時 ･･･ .+\d+\[mm\]/)
    end
  end
end
