require 'rails_helper'

RSpec.describe "LinesApiControllers", type: :request do
  describe '#webhock' do
    let(:request_file_dir)    { 'spec/fixtures/line_api/text_messages' }
    let(:request_file_name)   { 'city_request.json.erb' }
    let(:request_file_path)   { Rails.root + request_file_dir + request_file_name }
    let(:request_file)        { File.open(request_file_path) }
    let(:request_body)        { ERB.new(request_file.read).result }
    let(:double_events)       { Line::Bot::Client.new.parse_events_from(request_body) }

    let(:geocoding_file_dir)  { 'spec/fixtures/geocoding_api' }
    let(:geocoding_file_name) { 'success_response.xml' }
    let(:geocoding_file_path) { Rails.root + geocoding_file_dir + geocoding_file_name }
    let(:geocoding_response)  { File.open(geocoding_file_path).read }

    before do
      allow_any_instance_of(Weather).to receive(:call_geocoding_api) { geocoding_response }
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

    describe '初期の位置情報設定' do
      context 'ユーザーが初めてアクセスした時' do
        it 'Lineユーザーを作成すること' do
          expect { post lines_webhock_path }.to change(LineUser, :count).by(1)
        end
      end

      context 'ユーザーのアクセスが2回目の時' do
        let(:request_file_name) { 'absolute_user_id_request.json' }

        it 'Lineユーザーを作成しないこと' do
          post lines_webhock_path
          expect { post lines_webhock_path }.to_not change(LineUser, :count)
        end
      end

      context '無効なテキストイベントを受け取った時' do
        let(:geocoding_file_name) { 'error_response.xml' }

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
        let(:request_file_name) { 'location_request.json.erb' }

        it 'Weatherを作成すること' do
          expect { post lines_webhock_path }.to change(Weather, :count).by(1)
        end
      end
    end

    describe '対話モード' do
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
