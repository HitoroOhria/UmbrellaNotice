class ChangeColumnToLineApis < ActiveRecord::Migration[5.2]
  def up
    change_column :line_apis, :notice_time, :string, default: '7:00'
  end

  def down
    change_column :line_apis, :notice_time, :integer
  end
end
