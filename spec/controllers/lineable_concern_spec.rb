require 'rails_helper'

RSpec.describe "Lineable", type: :controller do
  controller ApplicationController do
    include Lineable
  end

  describe '#find_by_line_messages(file_name)' do
    let(:file_name) { 'hogehoge' }

    subject(:find_by_line_messages) { controller.find_by_line_messages(file_name) }

    context '"file_name"が存在しない時' do
      it 'LoadErrorを発生させること' do
        expect { find_by_line_messages }.to raise_error(LoadError, "No such file. name: #{file_name}")
      end
    end
  end

  describe '#read_text_message(file_path)' do
    let(:dir_path)       { 'lib/line_messages' }
    let(:dirs)           { %w[text rich_menu] }
    let(:file_paths)     { dirs.flat_map { |dir| Dir[Rails.root + dir_path + dir + '*.txt'] } }
    let(:txt_file_paths) { file_paths.select { |file_path| File.extname(file_path) == '.txt' } }

    it 'file の内容を文字列として取得できること' do
      txt_file_paths.each do |file_path|
        expect(controller.read_text_message(file_path)).to be_a String
      end
    end
  end

  describe 'read_erb_message(file_path, **locals)' do
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
      controller.read_erb_message(file_path, line_user: line_user, weather: weather)
    end

    context 'file_pathが".../notice_weather.txt.erb"の時' do
      let(:file_path) { File.open(Rails.root + 'lib/line_messages/text/notice_weather.txt.erb') }

      it '日付が表示されていること' do
        is_expected.to match(%r{\d{1,2}/\d{1,2} \(.\)})
      end

      it '天気予報が表示されていること' do
        is_expected.to match(/\d{2}時 +･･･ +. +.+/)
      end
    end
  end

  describe '#read_quick_reply(file_path)' do
    let(:dir_path)   { 'lib/line_messages/quick_reply' }
    let(:file_paths) { Dir[Rails.root + dir_path + '*.json'] }

    it 'file の内容をハッシュとして取得できること' do
      file_paths.each do |file_path|
        expect(controller.read_quick_reply(file_path)).to be_a Hash
      end
    end
  end
end
