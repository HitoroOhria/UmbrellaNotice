class AddNullFalseToWeathers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :weathers, :lat, false
    change_column_null :weathers, :lon, false
  end
end
