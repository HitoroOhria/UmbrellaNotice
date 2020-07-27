class AddLocatingAtToLineUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :line_users, :locating_at, :datetime
  end
end
