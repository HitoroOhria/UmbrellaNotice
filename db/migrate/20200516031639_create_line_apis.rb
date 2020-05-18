class CreateLineApis < ActiveRecord::Migration[5.2]
  def change
    create_table :line_apis do |t|
      t.string :notice_time, default: '7:00'
      t.string :line_id
      t.datetime :located_at
      t.references :user

      t.timestamps null: false
    end

    add_index :line_apis, :line_id
  end
end
