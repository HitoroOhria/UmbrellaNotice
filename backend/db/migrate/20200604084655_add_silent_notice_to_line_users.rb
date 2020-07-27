class AddSilentNoticeToLineUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :line_users, :silent_notice, :boolean, default: false, null: false
  end
end
