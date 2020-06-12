class CreateCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars do |t|
      t.string :google_id, unique: true
      t.references :user

      t.timestamps
    end
  end
end
