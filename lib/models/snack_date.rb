class SnackDate < ActiveRecord::Base
  belongs_to :snack
  belongs_to :child
end
