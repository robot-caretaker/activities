class CreateActivityData < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_data do |t|
      t.integer :company_id
      t.integer :driver_id
      t.datetime :timestamp
      t.float :latitude
      t.float :longitude
      t.float :accuracy
      t.float :speed

      t.timestamps
    end
  end
end
