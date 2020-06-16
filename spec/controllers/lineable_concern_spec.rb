require 'rails_helper'

RSpec.describe "Lineable", type: :controller do
  controller ApplicationController do
    include Lineable
  end

  describe '#read_message' do
    context 'ファイルの拡張子が".txt"の時' do
      let(:dir_path)   { 'lib/line_messages' }
      let(:dirs)       { %w[text rich_menu] }
      let(:file_paths) { dirs.flat_map { |dir| Dir[Rails.root + dir_path + dir + '*.txt'] } }
      let(:txt_files)  { file_paths.select { |file_path| File.extname(file_path) == '.txt' } }
      let(:file_names) { txt_files.map { |file_path| file_path[%r{line_messages/.+/(.+).txt}, 1] } }

      it 'file の内容を文字列として取得できること' do
        file_names.each do |file_name|
          expect(controller.read_message(file_name)).to be_a String
        end
      end
    end

    context 'file_nameが"notice_weather"の時' do
      let(:line_user)     { build(:line_user_with_weather, silent_notice: true) }
      let(:weather)       { line_user.weather }

      let(:dir_path)      { 'spec/fixtures/weather_api' }
      let(:file_name)     { 'fixed_clear_forecast.json' }
      let(:api_response)  { File.open(Rails.root + dir_path + file_name) }
      let(:json_forecast) { JSON.parse(api_response.read, symbolize_names: true) }

      before do
        allow(weather).to receive(:forecast).and_return(json_forecast)
      end

      subject do
        controller.read_message('notice_weather', line_user: line_user, weather: weather)
      end

      it '日付が表示されていること' do
        is_expected.to match(%r{\d{1,2}/\d{1,2} \(.\)})
      end

      it '天気予報が表示されていること' do
        is_expected.to match(/\d{2}時 +･･･ +. +.+/)
      end
    end
  end
end
