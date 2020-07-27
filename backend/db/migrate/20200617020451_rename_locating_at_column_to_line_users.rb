class RenameLocatingAtColumnToLineUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :line_users, :locating_at, :locating_from
  end
end
