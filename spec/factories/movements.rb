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

FactoryGirl.define do
  factory :movement do
    category  "Salary"
    notes     "Some notes"
    amount_cents 100
    association :account, factory: :cash_with_balance
  end
end
