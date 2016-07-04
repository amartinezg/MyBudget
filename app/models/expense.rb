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

class Expense < Movement
  validates_presence_of :date
  validates_presence_of :account
  validates :period, absence: true
  validate :amount_numericality, if: :account
  validates_inclusion_of :type, in: %w(Expense)

  aasm do
    state :billed
    state :reconciled

    event :bill do
      transitions from: :reconciled, to: :billed
    end

    event :reconcile, after_transaction: :increment_account_balance do
      transitions from: :created, to: :reconciled
    end
  end

  private
  def amount_numericality
    message = "must be #{credit_account ? "greater" : "less"} than 0"
    errors.add(:amount_cents, message) if invalid_amount?
  end

  def invalid_amount?
    non_credit_account && self.amount_cents.try(:>=, 0) ||
    credit_account && self.amount_cents.try(:<=, 0)
  end
end
