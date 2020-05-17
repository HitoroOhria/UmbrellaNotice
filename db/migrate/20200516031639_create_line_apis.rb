class CreateLineApis < ActiveRecord::Migration[5.2]
  def change
    create_table :line_apis do |t|
      t.boolean :locatable, default: false, null: false
      t.string :notice_time, default: '7:00'
      t.string :line_id
      t.references :user

      t.timestamps
    end

    add_index :line_apis, :line_id
  end
end
