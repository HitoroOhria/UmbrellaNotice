require 'rails_helper'

RSpec.describe "LinesApiController", type: :request do
  describe '#webhock' do
    let(:current_weather_api_response) { { coord: { lat: 34.539012, lon: 140.345897 } } }
    let(:request_file)                 { 'spec/fixtures/line_api/city_request.json.erb' }
    let(:request_body)                 { ERB.new(File.open(Rails.root + request_file).read).result }
    let(:double_events)                { Line::Bot::Client.new.parse_events_from(request_body) }

    before do
      allow_any_instance_of(Weather).to receive(:current_weather_api) { current_weather_api_response }
      allow_any_instance_of(LineApiController).to receive(:reply)
      allow_any_instance_of(LineApiController).to receive(:validate_signature)
      allow_any_instance_of(LineApiController).to receive(:events) { double_events }
    end

    context '位置情報の設定が済んでない時' do
      context 'ユーザーが初めてアクセスした時' do
        it 'Lineユーザーを作成すること' do
          expect { post line_webhock_path }.to change(LineUser, :count).by(1)
        end
      end

      context 'ユーザーのアクセスが2回目の時' do
        let(:request_file) { 'spec/fixtures/line_api/absolute_user_id_request.json' }

        it 'Lineユーザーを作成しないこと' do
          post line_webhock_path
          expect { post line_webhock_path }.to_not change(LineUser, :count)
        end
      end

      context '無効なテキストイベントを受け取った時' do
        let(:current_weather_api_response) { false }

        it 'Weatherを作成しないこと' do
          expect { post line_webhock_path }.to_not change(Weather, :count)
        end
      end

      context '有効なテキストイベントを受け取った時' do
        it 'Weatherを作成すること' do
          expect { post line_webhock_path }.to change(Weather, :count).by(1)
        end
      end

      context '位置情報イベントを受け取った時' do
        let(:request_file) { 'spec/fixtures/line_api/location_request.json.erb' }

        it 'Weatherを作成すること' do
          expect { post line_webhock_path }.to change(Weather, :count).by(1)
        end
      end
    end

    context '位置情報の設定が済んでいる時' do
      pending
    end
  end
end
