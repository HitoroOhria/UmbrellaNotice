require 'rails_helper'

RSpec.describe Weather, type: :model do
  describe '#take_forecast' do
    context 'エラーが発生し続ける時' do
      let(:weather)      { build(:base_weather) }
      let(:exception_io) { double('Exception IO') }

      before do
        allow(exception_io).to receive_message_chain(:status, :[]).with(0).and_return('302')
        allow(weather).to receive(:call_weather_api).and_raise(OpenURI::HTTPError.new('',exception_io))
      end

      it '3回までリトライし、falseを返すこと' do
        expect(weather).to receive(:retry_message).exactly(4).times
        expect(weather.take_forecast).to eq false
      end
    end
  end

  describe '#validate_city(text)' do
    let!(:weather) { create(:base_weather) }

    subject { weather.validate_city('渋谷') }

    context '引数が有効な市名でない時' do
      it '偽を返すこと' do
        allow(weather).to receive(:take_forecast) { false }
        is_expected.to be_falsey
      end
    end

    context '引数が有効な市名である時' do
      it '真を返すこと' do
        allow(weather).to receive(:take_forecast) { true }
        is_expected.to be_truthy
      end
    end
  end

  describe '#to_romaji(text)' do
    context '引数に日本語が渡された時' do
      it '一部以外、訓令式のローマ字であること' do
        romaji = Weather.new.to_romaji('長万部')
        expect(romaji).to eq 'osyamanbe'
      end

      it '「し」「ち」「つ」は「shi」「chi」「tsu」に変換すること' do
        romaji = Weather.new.to_romaji('しちつ')
        expect(romaji).to eq 'shichitsu'
      end
    end
  end

  describe '#save_city' do
    let!(:weather)    { build(:base_weather, city: 'shibuya') }
    let!(:line_user)  { create(:line_user, weather: weather) }
    let!(:located_at) { line_user.located_at }

    before do
      weather.save_city
    end

    it 'cityカラムが保存されること' do
      expect(weather.reload.city).to eq 'shibuya'
    end

    it '関連するLineユーザーのlocated_atカラムが更新されること' do
      expect(located_at).to_not eq line_user.reload.located_at
    end
  end

  describe '#save_location(lat, lon)' do
    let!(:weather)    { build(:base_weather) }
    let!(:line_user)  { create(:line_user, weather: weather) }
    let!(:located_at) { line_user.located_at }

    before do
      weather.save_location(35.659108, 139.703728)
    end

    it 'latカラムが保存されること' do
      expect(weather.reload.lat).to eq 35.66
    end

    it 'lonカラムが保存されること' do
      expect(weather.reload.lon).to eq 139.70
    end

    it '関連するLineユーザーのlocated_atカラムが更新されること' do
      expect(located_at).to_not eq line_user.reload.located_at
    end
  end

  describe '#take_forecast' do
    pending
  end
end
