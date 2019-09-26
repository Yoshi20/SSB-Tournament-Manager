class Registration < ApplicationRecord
  belongs_to :player
  belongs_to :tournament
  acts_as_list

end
