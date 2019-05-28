class Snack < ActiveRecord::Base
  has_many :snack_dates
  has_many :children, through :snack_dates
end
