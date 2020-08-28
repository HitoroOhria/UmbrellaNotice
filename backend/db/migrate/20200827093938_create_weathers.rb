class CreateWeathers < ActiveRecord::Migration[6.0]
  def change
    create_table :weathers do |t|
      t.belongs_to :line_user, index: true
      t.string :city
      t.decimal :lat, precision: 5, scale: 2
      t.decimal :lon, precision: 5, scale: 2

      t.timestamps
    end
  end
end
