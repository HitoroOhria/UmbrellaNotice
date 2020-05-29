require 'rails_helper'

RSpec.describe LineUser, type: :model do
  describe '.find_or_create(line_id)' do

    subject(:find_or_create) { LineUser.find_or_create(line_id) }

    context '引数に対応するLineユーザーが存在しないとき' do
      let(:line_id) { 'sample_line_id' }

      it '新しいLineユーザーを作成する' do
        expect { find_or_create }.to change(LineUser, :count).by(1)
      end

      it '新しいLineユーザーを返す' do
        is_expected.to eq LineUser.find_by(line_id: line_id)
      end
    end

    context '引数に対応するLineユーザーが存在するとき' do
      let(:line_id)    { line_user.line_id }
      let!(:line_user) { create(:line_user) }

      it '引数に対応するLineユーザーを返す' do
        is_expected.to eq line_user
      end
    end
  end
end
