class ChangeDateStringToBeDateInCreateSnackDates < ActiveRecord::Migration[5.0]
  def change
    change_column :snack_dates , :date , :date
  end
end
