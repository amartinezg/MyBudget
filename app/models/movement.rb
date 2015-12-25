class Movement < ActiveRecord::Base
  monetize :amount_cents, presence: true
  belongs_to :account

  scope :budgets, -> { where(race: 'Budget') } 
  scope :expenses, -> { where(race: 'Expense') } 
  scope :incomes, -> { where(race: 'Income') } 
end
