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
  validates_numericality_of :amount_cents, less_than: 0

  aasm do
    state :billed
    state :reconciled

    event :bill do
      transitions :from => :reconciled, :to => :billed
    end

    event :reconcile, :before_transaction => :decrement_account_balance do
      transitions :from => :created, :to => :reconciled
    end
  end

  private
  def decrement_account_balance
    self.account.decrement_balance(self.amount)
  end
end
