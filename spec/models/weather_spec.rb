require 'rails_helper'

RSpec.describe Weather, type: :model do
  describe 'Factory' do
    describe ':base_weather' do
      subject { create(:base_weather) }

      it { is_expected.to be_truthy }
    end

    describe ':weather' do
      subject(:weather) { create(:weather) }

      it { is_expected.to be_truthy }

      it '関連したUserファクトリーを作成すること' do
        expect(weather.user.persisted?).to be_truthy
      end

      it '関連したLineUserファクトリーを作成すること' do
        expect(weather.line_user.persisted?).to be_truthy
      end

      it '関連したLineUserファクトリーのlocated_atカラムを更新すること' do
        expect(weather.line_user.located_at).to be_present
      end
    end
  end

  describe 'Validates' do
    describe 'weathers.lat' do
      subject(:weather) { build(:base_weather, lat: latitude) }

      context '値が小数点第十六位まである時' do
        let(:latitude) { rand(-90.0...90.0) }

        it '小数点第二位まで丸めて保存すること' do
          weather.save
          expect(weather.reload.lat).to eq latitude.round(2)
        end
      end

      context '値が -91 の時' do
        let(:latitude) { -91 }

        it { is_expected.to_not be_valid }
      end

      context '値が -90 の時' do
        let(:latitude) { -90 }

        it { is_expected.to be_valid }
      end

      context '値が 90 の時' do
        let(:latitude) { 90 }

        it { is_expected.to be_valid }
      end

      context '値が 91 の時' do
        let(:latitude) { 91 }

        it { is_expected.to_not be_valid }
      end
    end

    describe 'weathers.lon' do
      subject(:weather) { build(:base_weather, lon: longitude) }

      context '値が小数点第十六位まである時' do
        let(:longitude) { rand(-180.0...180.0) }

        it '小数点第二位まで丸めて保存すること' do
          weather.save
          expect(weather.reload.lon).to eq longitude.round(2)
        end
      end

      context '値が -181 の時' do
        let(:longitude) { -181 }

        it { is_expected.to_not be_valid }
      end

      context '値が -180 の時' do
        let(:longitude) { -180 }

        it { is_expected.to be_valid }
      end

      context '値が 180 の時' do
        let(:longitude) { 180 }

        it { is_expected.to be_valid }
      end

      context '値が 181 の時' do
        let(:longitude) { 181 }

        it { is_expected.to_not be_valid }
      end
    end
  end

  describe '#today_is_rainy?' do
    let(:weather_dir_path)  { 'spec/fixtures/weather_api' }
    let(:weather_file_name) { 'fixed_clear_forecast.json' }
    let(:weather_file)      { File.open(Rails.root + weather_dir_path + weather_file_name) }

    let!(:weather)          { build(:base_weather) }
    let!(:weather_forecast) { JSON.parse(weather_file.read, symbolize_names: true) }

    before do
      allow(weather).to receive(:forecast).and_return(weather_forecast)
    end

    subject { weather.today_is_rainy? }

    context '天気予報の雨量が 0[mm] の時' do
      it { is_expected.to eq false }
    end

    context '天気予報の雨量が 2.9[mm] の時' do
      let(:weather_file_name) { 'cloudy_rain_forecast.json' }

      it { is_expected.to eq false }
    end

    context '天気予報の雨量が 3[mm] の時' do
      let(:weather_file_name) { 'rain_forecast.json' }

      it { is_expected.to eq true }
    end
  end

  describe '#add_and_save_location(text)' do
    let!(:weather) { build(:base_weather) }

    before do
      allow(weather).to receive(:current_weather_api).and_return(api_response)
      allow(weather).to receive(:save_location).with(any_args)
    end

    subject(:add_and_save_location) { weather.add_and_save_location('渋谷区') }

    context 'APIコールのレスポンスが有効なJSONの場合' do
      let(:api_response) { { coord: { lat: 34.408413, lon: 140.229085 } } }

      it '#save_location(lat, lon)を呼び出すこと' do
        expect(weather).to receive(:save_location).once
        add_and_save_location
      end
    end

    context 'APIコールのレスポンスがfalseの場合' do
      let(:api_response) { false }

      it { is_expected.to eq nil }
    end
  end

  describe '#to_romaji(text)' do
    context '引数に日本語が渡された時' do
      let(:weather) { build(:base_weather) }

      it '一部以外、訓令式のローマ字であること' do
        expect(weather.to_romaji('長万部')).to eq 'osyamanbe'
      end

      it '「し」「ち」「つ」は「shi」「chi」「tsu」に変換すること' do
        expect(weather.to_romaji('しちつ')).to eq 'shichitsu'
      end

      context '文字列の末尾に「市」がついていた時' do
        it '「市」を除いたローマ字であること' do
          expect(weather.to_romaji('かすみがうら市')).to eq 'kasumigaura'
        end
      end

      context '文字列の末尾に「区」がついていた時' do
        it '「区」を除いたローマ字であること' do
          expect(weather.to_romaji('渋谷区')).to eq 'shibuya'
        end
      end
    end
  end

  describe '#save_location(lat, lon)' do
    let!(:weather)    { build(:base_weather) }
    let!(:line_user)  { create(:line_user, weather: weather) }
    let!(:located_at) { line_user.located_at }

    before do
      weather.save_location(35.659108, 139.703728)
    end

    it 'latカラムが小数点第二位に丸められて保存されること' do
      expect(weather.reload.lat).to eq 35.66
    end

    it 'lonカラムが小数点第二位に丸められて保存されること' do
      expect(weather.reload.lon).to eq 139.70
    end

    it '関連するLineユーザーのlocated_atカラムが更新されること' do
      expect(located_at).to_not eq line_user.reload.located_at
    end
  end

  describe '#take_api_and_error_handling(api_type, request_query)' do
    context 'エラーが発生し続ける時' do
      let(:weather)      { build(:base_weather) }
      let(:exception_io) { double('Exception IO') }
      let(:http_error)   { OpenURI::HTTPError.new('', exception_io) }

      before do
        allow(exception_io).to receive_message_chain(:status, :[]).with(0).and_return('302')
        allow(weather).to      receive(:call_weather_api).with(any_args).and_raise(http_error)
      end

      it '3回までリトライし、falseを返すこと' do
        expect(weather).to receive(:retry_message).exactly(4).times
        expect(weather.send(:take_api_and_error_handling, 'api', 'hoge')).to eq false
      end
    end
  end

  describe '#call_weather_api(api_type, request_query)' do
    let(:api_response) { StringIO.new('{ "weather": "clear" }') }
    let(:weather)      { build(:base_weather) }

    before do
      allow(OpenURI).to receive(:open_uri).and_return(api_response)
    end

    subject(:call_weather_api) { weather.send(:call_weather_api, api_type, 'hoge') }

    context 'api_type が "onecall" の時' do
      let(:api_type) { 'onecall' }

      it '#refill_rain(json_forecast) を呼び出すこと' do
        expect(weather).to receive(:refill_rain).once
        call_weather_api
      end
    end

    context 'api_type が "onecall" 以外の時' do
      let(:api_type)      { 'weather' }
      let(:json_response) { { weather: 'clear' } }

      it 'Hashに変換したAPIレスポンスを返すこと' do
        is_expected.to eq json_response
      end
    end
  end

  describe '#def refill_rain(json_forecast)' do
    let(:weather_dir_path)  { 'spec/fixtures/weather_api' }
    let(:weather_file_name) { 'clear_forecast.json' }
    let(:weather_file)      { File.open(Rails.root + weather_dir_path + weather_file_name) }

    let!(:weather)          { build(:base_weather) }
    let!(:json_forecast)    { JSON.parse(weather_file.read, symbolize_names: true) }

    subject(:refill_rain) { weather.send(:refill_rain, json_forecast) }

    context 'json_forecast の :hourly の天気が雨以外の時' do
      it '雨量 0[mm] を追加すること' do
        refill_rain[:hourly].each do |hourly|
          expect(hourly[:rain][:'1h']).to eq 0
        end
      end
    end

    context 'json_forecast の :hourly の天気が雨の時' do
      context '雨量が 3[mm] 未満の時' do
        let(:weather_file_name) { 'cloudy_rain_forecast.json' }

        it '天気を曇りに変更すること' do
          refill_rain[:hourly].each do |hourly|
            hourly[:weather].each do |weather|
              expect(weather[:id]).to          eq 804
              expect(weather[:main]).to        eq 'Clouds'
              expect(weather[:description]).to eq 'overcast clouds'
              expect(weather[:icon]).to        eq '04d'
            end
          end
        end
      end

      context '雨量が 3[mm] 以上の時' do
        let(:weather_file_name) { 'rain_forecast.json' }

        it '変更を加えないこと' do
          is_expected.to eq json_forecast
        end
      end
    end
  end
end
