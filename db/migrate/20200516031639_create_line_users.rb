class CreateLineUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :line_users do |t|
      t.string :line_id
      t.string :notice_time, default: '7:00'
      t.datetime :located_at

      t.timestamps null: false
    end

    add_index :line_users, :line_id
  end
end
