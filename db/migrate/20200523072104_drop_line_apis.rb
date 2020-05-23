class DropLineApis < ActiveRecord::Migration[5.2]
  def change
    drop_table :line_apis
  end
end
