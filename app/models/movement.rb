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

  scope :budgets, -> { where(type: 'Budget') }
  scope :expenses, -> { where(type: 'Expense') }
  scope :incomes, -> { where(type: 'Income') }

  aasm do
    state :created, :initial => true
  end
end
