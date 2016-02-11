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

class Movement < ActiveRecord::Base
  include Categories
  include AASM

  monetize :amount_cents, presence: true, as: "amount"
  belongs_to :account
  validates_presence_of :category, :type, :amount_cents
  validates_inclusion_of :type, in: %w(Budget Expense Income)
  validates_inclusion_of :category, in: :categories
  validates_inclusion_of :sub_category, in: :check_sub_category, if: :category
  validate :account_currency, if: :account

  scope :budgets, -> { where(type: 'Budget') }
  scope :expenses, -> { where(type: 'Expense') }
  scope :incomes, -> { where(type: 'Income') }

  aasm do
    state :created, :initial => true
  end

  private
  def check_sub_category
    sub_categories_for(self.category) || []
  end

  def account_currency
    message = "Amount's currency should be equal to account's balance currency"
    errors.add(:base, message) if self.account.balance.currency != self.amount.currency
  end

  def increment_account_balance
    self.account.increment_balance(self.amount)
  end
end
