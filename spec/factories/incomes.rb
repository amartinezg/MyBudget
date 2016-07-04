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

FactoryGirl.define do
  factory :income do
    type          "Income"
    notes         "Income from salary"
    date          Date.current

    trait :non_credit do
      amount Money.new 1000
      association :account, factory: :cash_with_balance
    end

    trait :credit do
      amount Money.new -1000
      association :account, factory: :credit_card_with_balance
    end

    trait :with_category do
      category "income"
    end

    trait :with_sub_category do
      sub_category "freelance"
    end

    factory :valid_income,  traits: [:with_category, :with_sub_category, :credit]
    factory :non_credit_income,  traits: [:with_category, :with_sub_category, :non_credit]
  end
end
