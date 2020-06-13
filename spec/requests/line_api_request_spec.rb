require 'rails_helper'

RSpec.describe "LinesApiControllers", type: :request do
  describe '#webhock' do
    let(:request_file_dir)       { 'spec/fixtures/line_api' }
    let(:request_file_name)      { 'city_request.json.erb' }
    let(:request_file_path)      { Rails.root + request_file_dir + request_file_name }
    let(:request_body)           { ERB.new(File.open(request_file_path).read).result }

    let(:double_events)          { Line::Bot::Client.new.parse_events_from(request_body) }
    let(:city_to_coord_response) { { lat: 34.539012, lon: 140.345897 } }

    before do
      allow_any_instance_of(Weather).to receive(:city_to_coord) { city_to_coord_response }
      allow_any_instance_of(LineApiController).to receive(:reply)
      allow_any_instance_of(LineApiController).to receive(:validate_signature)
      allow_any_instance_of(LineApiController).to receive(:events) { double_events }
    end

    subject { response }

    describe 'レスポンス' do
      before do
        post lines_webhock_path
      end

      it { is_expected.to have_http_status 200 }
    end

    context '位置情報の設定が済んでない時' do
      context 'ユーザーが初めてアクセスした時' do
        it 'Lineユーザーを作成すること' do
          expect { post lines_webhock_path }.to change(LineUser, :count).by(1)
        end
      end

      context 'ユーザーのアクセスが2回目の時' do
        let(:request_file) { 'spec/fixtures/line_api/absolute_user_id_request.json' }

        it 'Lineユーザーを作成しないこと' do
          post lines_webhock_path
          expect { post lines_webhock_path }.to_not change(LineUser, :count)
        end
      end

      context '無効なテキストイベントを受け取った時' do
        let(:city_to_coord_response) { nil }

        it 'Weatherを作成しないこと' do
          expect { post lines_webhock_path }.to_not change(Weather, :count)
        end
      end

      context '有効なテキストイベントを受け取った時' do
        it 'Weatherを作成すること' do
          expect { post lines_webhock_path }.to change(Weather, :count).by(1)
        end
      end

      context '位置情報イベントを受け取った時' do
        let(:request_file) { 'spec/fixtures/line_api/location_request.json.erb' }

        it 'Weatherを作成すること' do
          expect { post lines_webhock_path }.to change(Weather, :count).by(1)
        end
      end
    end

    context '位置情報の設定が済んでいる時' do
      let(:request_file_name) { 'absolute_user_id_request.json' }

      before do
        post lines_webhock_path
      end

      it 'HTTPステータス200を返すこと' do
        post lines_webhock_path
        is_expected.to have_http_status 200
      end
    end
  end
end
