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

class Expense < Movement 
  validates :period, absence: true
  validates_numericality_of :amount_cents, less_than: 0
end
