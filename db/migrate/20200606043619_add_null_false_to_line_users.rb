class AddNullFalseToLineUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :line_users, :line_id, false
  end
end
