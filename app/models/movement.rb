# == Schema Information
#
# Table name: movements
#
#  id           :integer          not null, primary key
#  category     :string
#  sub_category :string
#  notes        :string
#  amount_cents :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  period       :date
#  account_id   :string           not null
#  date         :date
#

class Movement < ActiveRecord::Base
  monetize :amount_cents, presence: true
  belongs_to :account

  scope :budgets, -> { where(race: 'Budget') } 
  scope :expenses, -> { where(race: 'Expense') } 
  scope :incomes, -> { where(race: 'Income') } 
end
