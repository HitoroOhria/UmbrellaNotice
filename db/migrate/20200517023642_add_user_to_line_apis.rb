class AddUserToLineApis < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_apis, :user, foreign_key: true
  end
end
