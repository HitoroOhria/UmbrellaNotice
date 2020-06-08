require 'rails_helper'

RSpec.describe LineUser, type: :model do
  describe 'Factory' do
    describe ':line_user' do
      subject { create(:line_user) }

      it { is_expected.to be_truthy }
    end

    describe ':line_user_with_weather' do
      subject(:line_user) { create(:line_user_with_weather) }

      it { is_expected.to be_truthy }

      it '関連したWeatherを作成すること' do
        expect(line_user.weather).to be_present
      end
    end
  end

  describe 'Validates' do
    describe 'line_users.notice_time' do
      context '値が /\d{2}:\d{2}/ にマッチしない時' do
        let(:error_message) { '"07:00"のような時刻表現にする必要があります' }

        subject(:line_user) { build(:line_user, notice_time: '7:00') }

        it { is_expected.to_not be_valid }

        it 'エラーメッセージを表示すること' do
          line_user.valid?
          expect(line_user.errors[:notice_time]).to include(error_message)
        end
      end

      context '値が /\d{2}:\d{2}/ にマッチする時' do
        subject { build(:line_user, notice_time: '07:00') }

        it { is_expected.to be_valid }
      end
    end
  end
end
