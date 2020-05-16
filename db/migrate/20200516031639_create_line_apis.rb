class CreateLineApis < ActiveRecord::Migration[5.2]
  def change
    create_table :line_apis do |t|
      t.boolean :locatable
      t.integer :notice_time
      t.string :line_id

      t.timestamps
    end
  end

  add_index :line_apis, :line_id
end
