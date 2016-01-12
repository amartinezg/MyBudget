# == Schema Information
#
# Table name: movements
#
#  id              :integer          not null, primary key
#  category        :string
#  sub_category    :string
#  notes           :string
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  period          :date
#  account_id      :string
#  date            :date
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("COP"), not null
#  aasm_state      :string
#

class Budget < Movement
  validates :period, presence: true
  validates_numericality_of :amount_cents, greater_than: 0
  validate :period_greater_than_this_month
  validates_absence_of :account, message: "must be no account associated"
  validates_absence_of :date, message: "must not have date of movement"

  aasm do
    state :running
    state :closed

    event :run do
      transitions :from => :created, :to => :running, :if => :can_run?
    end

    event :close do
      transitions :from => :running, :to => :closed, :if => :can_close?
    end
  end

  private
  def can_run?
    self.period == Date.today.beginning_of_month
  end

  def can_close?
    self.period < Date.today.beginning_of_month
  end

  def period_greater_than_this_month
    errors.add(:base, "Period should be at least of the next month.") unless period.try(:>, Date.today.end_of_month)
  end
end
