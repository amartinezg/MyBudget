class Account < ActiveRecord::Base
  monetize :balance_cents, presence: true
  has_many :movements
end
