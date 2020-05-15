class CreateWeatherApis < ActiveRecord::Migration[5.2]
  def change
    create_table :weather_apis do |t|
      t.string :city
      t.integer :lat
      t.integer :lon
      t.references :user

      t.timestamps
    end
  end
end
