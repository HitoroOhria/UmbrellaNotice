class CreateWeathers < ActiveRecord::Migration[5.2]
  def change
    create_table :weathers do |t|
      t.string :city
      t.decimal :lat, precision: 4, scale: 2
      t.decimal :lon, precision: 5, scale: 2
      t.references :user
      t.references :line_user

      t.timestamps null: false
    end
  end
end
