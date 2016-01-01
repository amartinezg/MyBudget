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
#

FactoryGirl.define do
  factory :movement do
    notes     "Some notes"
    amount_cents 100
    association :account, factory: :cash_with_balance
  end

  factory :budget do
    notes     "Some notes"
    amount_cents 100

    trait :budget do
      type "Budget"
    end

    trait :with_category do
      category "income"
    end

    trait :without_category do
      category nil
    end

    trait :with_sub_category do
      category "salary"
    end

    trait :with_period do
      period Time.now.beginning_of_month.next_month.to_date
    end

    trait :with_invalid_period do
      period Time.now.beginning_of_month.to_date
    end

    trait :without_date do
      date nil
    end

    factory :valid_budget,  traits: [:budget, :with_category, :with_sub_category, :with_period, :without_date]
  end
end
