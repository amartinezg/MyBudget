class Expense < Movement 
  validates :period, absence: true
  validates_numericality_of :amount_cents, less_than: 0
end