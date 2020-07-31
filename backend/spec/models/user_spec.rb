require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    describe ':user' do
      subject { create(:user) }

      it { is_expected.to be_truthy }
    end

    describe ':user_with_weather' do
      subject(:user) { create(:user_with_weather) }

      it { is_expected.to be_truthy }

      it '関連したWeatherを作成すること' do
        expect(user.weather).to be_present
      end
    end
  end
end
