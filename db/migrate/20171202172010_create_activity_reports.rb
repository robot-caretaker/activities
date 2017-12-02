class CreateActivityReports < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_reports do |t|
      t.integer :company_id
      t.integer :driver_id
      t.datetime :from
      t.datetime :to
      t.string :activity

      t.timestamps
    end
  end
end
