require 'rails_helper'

RSpec.describe Weather, type: :model do
  let(:weather)                 { build(:base_weather) }
  let(:fixtures_dir_path)       { Rails.root + 'spec/fixtures' }

  let(:weather_api_dir)         { 'weather_api' }
  let(:one_call_api_file)       { 'fixed_clear_forecast.json' }
  let!(:one_call_api_response)  { File.open(fixtures_dir_path + weather_api_dir + one_call_api_file) }

  let(:geocoding_api_dir)       { 'geocoding_api' }
  let(:geocoding_api_file)      { 'success_response.xml' }
  let(:geocoding_api_file_path) { fixtures_dir_path + geocoding_api_dir + geocoding_api_file }
  let(:geocoding_api_response)  { File.open(geocoding_api_file_path).read }

  before do
    allow(weather).to receive(:call_one_call_api).and_return(one_call_api_response)
    allow(weather).to receive(:call_geocoding_api).and_return(geocoding_api_response)
  end

  describe 'Factory' do
    describe ':base_weather' do
      subject { create(:base_weather) }

      it { is_expected.to be_truthy }
    end

    describe ':weather' do
      subject(:weather) { create(:weather) }

      it { is_expected.to be_truthy }

      it '関連したLineUserファクトリーを作成すること' do
        expect(weather.line_user).to be_present
      end

      it '関連したLineUserファクトリーのlocated_atカラムを更新すること' do
        expect(weather.line_user.located_at).to be_present
      end
    end
  end

  describe 'Validates' do
    describe 'weathers.lat' do
      subject(:weather) { build(:base_weather, lat: latitude) }

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

  describe 'Before Validation' do
    describe 'weathers.city' do
      subject(:weather) { build(:base_weather, city: city_name) }

      context '値がnilの時' do
        let(:city_name) { '渋谷' }

        before do
          weather.save
          weather.city = nil
        end

        it { expect(weather.save).to be_truthy }

        it '変更を加えないこと' do
          weather.valid?
          expect(weather.city).to eq nil
        end
      end

      context '値が「渋谷」の時' do
        let(:city_name) { '渋谷' }

        it 'self.cityの末尾に「市」を付けること' do
          weather.valid?
          expect(weather.city).to eq '渋谷市'
        end
      end

      context '値が「かすみがうら」の時' do
        let(:city_name) { 'かすみがうら' }

        it 'self.cityの末尾に「市」を付けること' do
          weather.valid?
          expect(weather.city).to eq 'かすみがうら市'
        end
      end

      context '値が「渋谷区」の時' do
        let(:city_name) { '渋谷区' }

        it { is_expected.to be_valid }
      end

      context '値が「かすみがうら市」の時' do
        let(:city_name) { 'かすみがうら市' }

        it { is_expected.to be_valid }
      end
    end
  end

  describe '#romaji_city' do
    let(:weather) { build(:base_weather, city: '渋谷区') }

    subject { weather.romaji_city }

    it 'self.city の一文字目が大文字を変換したローマ字を返すこと' do
      is_expected.to eq 'Shibuya'
    end
  end

  describe '#today_is_rainy?' do
    subject { weather.today_is_rainy? }

    context '天気予報の雨量が 0[mm] の時' do
      it { is_expected.to eq false }
    end

    context '天気予報の雨量が 0.79[mm] の時' do
      let(:one_call_api_file) { 'cloudy_rain_forecast.json' }

      it { is_expected.to eq false }
    end

    context '天気予報の雨量が 0.8[mm] の時' do
      let(:one_call_api_file) { 'rain_forecast.json' }

      it { is_expected.to eq true }
    end
  end

  describe '#complement_city(city_name)' do
    subject(:complement_city) { weather.complement_city('渋谷') }

    context '#geocodingのリターンがfalseの時' do
      let(:geocoding_api_response) { false }

      it { is_expected.to eq nil }
    end

    context 'geocodingのリターンがREXML::Documentの時' do
      it 'self.cityに、APIレスポンスの市名を代入すること' do
        is_expected.to eq '渋谷区'
      end
    end
  end

  describe '#city_to_coord' do
    subject { weather.send(:city_to_coord) }

    context '#geocoding_apiのレスポンスがエラーの時' do
      let(:geocoding_api_file) { 'error_response.xml' }

      it { is_expected.to be_falsey }
    end

    context '#geocoding_apiのレスポンスが成功の時' do
      let(:return_hash) { { lat: 35.661971, lon: 139.703795 } }

      it { is_expected.to eq return_hash }
    end
  end

  describe '#save_location(lat, lon)' do
    let(:current_time)  { Time.zone.now }
    let(:located_at)    { current_time }
    let(:locating_from) { current_time }

    let!(:weather)      { build(:base_weather) }
    let!(:line_user)    {
      create(:line_user, weather: weather, located_at: located_at, locating_from: locating_from)
    }

    before do
      weather.save_location(lat: 35.659108, lon: 139.703728)
    end

    describe 'カラムの値' do
      it 'latカラムが小数点第二位に丸められて保存されること' do
        expect(weather.reload.lat).to eq 35.66
      end

      it 'lonカラムが小数点第二位に丸められて保存されること' do
        expect(weather.reload.lon).to eq 139.70
      end
    end

    context '関連するLineUserの.located_atの値がない時' do
      let(:located_at) { nil }

      it '関連するLineUserの.located_atを更新すること' do
        expect(line_user.reload.located_at).to_not eq nil
      end
    end

    context '関連するLineUserの.located_atの値がある時' do
      it '関連するLineUserの.located_atを更新しない' do
        expect(line_user.reload.located_at).to_not eq current_time
      end
    end

    context '関連するLineUserの.locating_fromの値がない時' do
      let(:locating_from) { nil }

      it '関連するLineUserの.locating_fromを更新しない' do
        expect(line_user.reload.locating_from).to eq nil
      end
    end

    context '関連するLineUserの.locating_fromの値がある時' do
      it '関連するLineUserの.locating_fromを更新すること' do
        expect(line_user.reload.locating_from).to_not eq current_time
      end
    end
  end

  describe '#call_api_and_handle_error(api_name)' do
    context 'エラーが発生し続ける時' do
      let(:weather)      { build(:base_weather) }
      let(:exception_io) { double('Exception IO') }
      let(:http_error)   { OpenURI::HTTPError.new('', exception_io) }

      before do
        allow(exception_io).to receive_message_chain(:status, :[]).with(0).and_return('302')
        allow(weather).to      receive(:call_geocoding_api).and_raise(http_error)
      end

      it '3回までリトライし、falseを返すこと' do
        expect(weather).to receive(:retry_message).exactly(4).times
        expect(weather.send(:call_api_and_handle_error, 'geocoding')).to eq false
      end
    end
  end

  describe '#to_romaji(text)' do
    context '引数に日本語が渡された時' do
      let(:weather) { build(:base_weather) }

      it '一部以外、訓令式のローマ字であること' do
        expect(weather.send(:to_romaji, '長万部')).to eq 'osyamanbe'
      end

      it '「し」「ち」「つ」は「shi」「chi」「tsu」に変換すること' do
        expect(weather.send(:to_romaji, 'しちつ')).to eq 'shichitsu'
      end
    end
  end

  describe '#refill_rain(json_forecast)' do
    let!(:json_forecast)    { JSON.parse(one_call_api_response.read, symbolize_names: true) }

    subject(:refill_rain) { weather.send(:refill_rain, json_forecast) }

    context 'json_forecast の :hourly の天気が雨以外の時' do
      it '雨量 0[mm] を追加すること' do
        refill_rain[:hourly].each do |hourly|
          expect(hourly[:rain][:'1h']).to eq 0
        end
      end
    end

    context 'json_forecast の :hourly の天気が雨の時' do
      context '雨量が 0.8[mm] 未満の時' do
        let(:one_call_api_file) { 'cloudy_rain_forecast.json' }

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

      context '雨量が 0.8[mm] 以上の時' do
        let(:weather_file_name) { 'rain_forecast.json' }

        it '変更を加えないこと' do
          is_expected.to eq json_forecast
        end
      end
    end
  end
end
