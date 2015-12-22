class Income < Movement 
  validates :period, absence: true
  validates_numericality_of :amount_cents, greater_than: 0
end