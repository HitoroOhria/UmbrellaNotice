class CreateLineUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :line_users do |t|
      t.belongs_to :user, index: true
      t.string :line_id, null: false
      t.string :notice_time, default: "07:00", null: false
      t.boolean :silent_notice, default: true, null: false
      t.string :auth_token
      t.string :inherit_token
      t.datetime :located_at
      t.datetime :locating_from

      t.timestamps
    end

    add_index :line_users, :line_id, unique: true
    add_index :line_users, :auth_token, unique: true
    add_index :line_users, :inherit_token, unique: true
  end
end
