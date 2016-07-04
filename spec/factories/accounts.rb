# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  name             :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  balance_cents    :integer          default(0), not null
#  balance_currency :string           default("COP"), not null
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
      sequence :name do |n|
        "Account # #{n}"
      end
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

    trait :with_movements do
      transient do
        movements_count 5
      end

      after(:create) do |account, evaluator|
        create_list(:movement, evaluator.movements_count, account: account)
      end
    end

    factory :cash_with_balance,    traits: [:cash, :with_balance, :with_name]
    factory :cash_withouth_name,   traits: [:cash, :without_name]
    factory :account_with_movements, traits: [:cash, :with_balance, :with_name, :with_movements]
    factory :credit_card_with_balance, traits: [:credit, :with_balance, :with_name]

  end
end
