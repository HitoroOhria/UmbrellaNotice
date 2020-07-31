class AddInheritTokenToLineUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :line_users, :inherit_token, :string
    add_index :line_users, :inherit_token, unique: true

    rename_column :line_users, :token, :auth_token
  end
end
