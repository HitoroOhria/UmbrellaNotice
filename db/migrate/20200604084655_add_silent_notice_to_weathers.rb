class AddSilentNoticeToWeathers < ActiveRecord::Migration[5.2]
  def change
    add_column :weathers, :silent_notice, :boolean, default: false
  end
end
