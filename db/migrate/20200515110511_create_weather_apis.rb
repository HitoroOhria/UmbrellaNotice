class CreateWeatherApis < ActiveRecord::Migration[5.2]
  def change
    create_table :weather_apis do |t|
      t.string :city
      t.decimal :lat, precision: 5, scale: 2
      t.decimal :lon, precision: 6, scale: 2
      t.references :user

      t.timestamps null: false
    end
  end
end
