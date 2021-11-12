class UserAccDetail < ApplicationRecord
  belongs_to :user
  validates :account_number, :ifsc, :inflow, :outflow, presence: true
end
