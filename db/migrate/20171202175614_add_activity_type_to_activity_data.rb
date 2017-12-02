class AddActivityTypeToActivityData < ActiveRecord::Migration[5.1]
  def change
    add_column :activity_data, :activity, :string
  end
end
