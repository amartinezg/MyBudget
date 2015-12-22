class Budget < Movement 
  validates :period, presence: true
  validates_numericality_of :amount_cents, greater_than: 0
  validate :period_greater_than_this_month

  private
  def period_greater_than_this_month
    errors.add(:base, "Period should be at least of the next month.") unless period.try(:>, Date.today.end_of_month)
  end
end