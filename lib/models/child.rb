class Child < ActiveRecord::Base
    has_many :snack_dates
    has_many :snacks, through: :snack_dates
end
