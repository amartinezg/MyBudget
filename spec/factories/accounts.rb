# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  name          :string
#  type          :string
#  balance_cents :integer
#  currency      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :account do

    trait :credit do
      type :credit
    end

    trait :cash do
      type :cash
    end

    trait :saving do
      type :saving
    end

    trait :cop do
      currency :cop
    end

    trait :usd do
      currency :usd
    end

    trait :with_name do
      name "Mastercard Credit Card"
    end

    trait :without_name do
      name nil
    end

    trait :with_balance do
      balance Money.new 1000
    end

    trait :with_negative_balance do
      balance Money.new -1000
    end

    factory :cash_with_balance,    traits: [:cash, :with_balance, :with_name]
    factory :cash_withouth_name,   traits: [:cash, :without_name]
    factory :account_with_movements do

    end
  end
end
