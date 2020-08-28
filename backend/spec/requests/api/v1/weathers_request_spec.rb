require 'rails_helper'

RSpec.describe "Api::V1::Weathers", type: :request do
  # stub call Geocoding API.
  let(:geocoding_file_dir)  { 'spec/fixtures/geocoding_api' }
  let(:geocoding_file_name) { 'success_response.xml' }
  let(:geocoding_file_path) { Rails.root + geocoding_file_dir + geocoding_file_name }
  let(:geocoding_response)  { File.open(geocoding_file_path).read }

  before do
    allow_any_instance_of(Weather).to receive(:call_geocoding_api) { geocoding_response }
  end

  # defined shorthand.
  let(:error_msg)    { ERROR_MSG[:WEATHER] }
  let(:update_attrs) { UPDATE_ATTRS[:WEATHER] }

  # Define weather.
  let(:success_response) {
    {
      'id' => weather.id,
      'city' => weather.city,
      'lat' => weather.lat.to_s,
      'lon' => weather.lon.to_s
    }
  }

  # Define user if used.
  let(:user_response) {
    {
      'id' => user.id,
      'email' => user.email
    }
  }

  # Define line_user if used.
  let(:line_user_response) {
    {
      'id' => line_user.id,
      'notice_time' => line_user.notice_time,
      'silent_notice' => line_user.silent_notice
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
    let!(:weather) { create(:base_weather) }
    let(:id)       { weather.id }
    let(:embed)    { nil }

    before do
      get api_v1_weather_path(id), params: { embed: embed }
    end

    describe '正常系' do
      context 'embedがnilのとき' do
        it { is_expected.to have_http_status 200 }

        it 'idに対応したWeatherモデル属性のJSONを返すこと' do
          expect(JSON.parse(response.body)).to eq success_response
        end
      end

      # TODO: Why response.body['user'] = nil ?
      # context 'embedがline_userのとき' do
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
    let!(:weather) { create(:base_weather) }
    let(:id)       { weather.id }
    let(:city)     { nil }
    let(:lat)      { nil }
    let(:lon)      { nil }

    before do
      put api_v1_weather_path(id),
          params: {
            city: city,
            lat:  lat,
            lon:  lon
          }
    end

    describe '正常系' do
      describe 'city' do
        let(:city)                { 'さいたま市' }
        let(:geocoding_file_name) { 'saitama_response.xml' }

        it { is_expected.to have_http_status 200 }

        it 'city,lat,lonを更新したWeatherモデルの属性のJSONを返すこと' do
          updated_weather = build(:weather, :saitama)
          weather.city    = updated_weather.city
          weather.lat     = updated_weather.lat
          weather.lon     = updated_weather.lon
          expect(JSON.parse(response.body)).to eq success_response
        end
      end

      describe 'lat,lon' do
        let(:lat) { 55.55 }
        let(:lon) { 133.33 }

        it { is_expected.to have_http_status 200 }

        it '更新後のWeatherモデルの属性のJSONを返すこと' do
          weather.lat = lat
          weather.lon = lon
          expect(JSON.parse(response.body)).to eq success_response
        end
      end

      describe 'city,lat,lon' do
        let(:city)                { 'さいたま市' }
        let(:lat)                 { 55.55 }
        let(:lon)                 { 133.33 }
        let(:geocoding_file_name) { 'saitama_response.xml' }

        it { is_expected.to have_http_status 200 }

        it 'cityのlat,lonで更新したWeatherモデルの属性のJSONを返すこと' do
          updated_weather = build(:weather, :saitama)
          weather.city    = updated_weather.city
          weather.lat     = updated_weather.lat
          weather.lon     = updated_weather.lon
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

      describe 'city' do
        context '存在しないcityを指定したとき' do
          let(:city)                { 'ほげふが市' }
          let(:geocoding_file_name) { 'error_response.xml' }
          let(:error_params)        {
            { 'city' => [error_msg[:CITY][:NOT_SEARCH][city]] }
          }

          it { is_expected.to have_http_status 400 }

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end
      end

      describe 'lat,lon' do
        let(:lat) { 55.55 }
        let(:lon) { 133.33 }

        context 'latのみを指定したとき' do
          let(:lon)          { nil }
          let(:error_params) {
            { 'lon' => [error_msg[:LON][:BLANK]] }
          }

          it { is_expected.to have_http_status 400 }

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'lonのみを指定したとき' do
          let(:lat)          { nil }
          let(:error_params) {
            { 'lat' => [error_msg[:LAT][:BLANK]] }
          }

          it { is_expected.to have_http_status 400 }

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'latの値が-90未満のとき' do
          let(:lat)          { -91 }
          let(:error_params) {
            { 'lat' => [error_msg[:LAT][:VALIDATE]] }
          }

          it { is_expected.to have_http_status 400 }

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'latの値が90を超過するとき' do
          let(:lat)          { 91 }
          let(:error_params) {
            { 'lat' => [error_msg[:LAT][:VALIDATE]] }
          }

          it { is_expected.to have_http_status 400 }

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'lonの値が-180未満のとき' do
          let(:lon)          { -181 }
          let(:error_params) {
            { 'lon' => [error_msg[:LON][:VALIDATE]] }
          }

          it { is_expected.to have_http_status 400 }

          it 'エラーレスポンスを返すこと' do
            expect(JSON.parse(response.body)).to eq error_response
          end
        end

        context 'lonの値は180を超過するとき' do
          let(:lon)          { 181 }
          let(:error_params) {
            { 'lon' => [error_msg[:LON][:VALIDATE]] }
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
    let!(:weather) { create(:base_weather) }
    let(:id)       { weather.id }

    before do
      delete api_v1_weather_path(id)
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
