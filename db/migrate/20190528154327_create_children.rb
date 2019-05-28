class CreateChildren < ActiveRecord::Migration[5.0]
  def change
    create_table :children do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :phone
    end
  end
end
