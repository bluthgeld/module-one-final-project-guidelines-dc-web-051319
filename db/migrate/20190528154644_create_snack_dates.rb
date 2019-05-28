class CreateSnackDates < ActiveRecord::Migration[5.0]
  def change
    create_table :snack_dates do |t|
      t.string :date
      t.integer :quantity
      t.integer :snack_id
      t.integer :child_id
    end
  end
end
