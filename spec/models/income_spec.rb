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

require 'rails_helper'

RSpec.describe Income, type: :model do

  describe "#amount" do
    let (:income) { build :valid_income}
    it "should be monetized" do
      expect(income).to monetize(:amount).with_currency(:cop)
    end
  end

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:account) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_presence_of(:amount_cents) }
    it { should validate_numericality_of(:amount_cents).is_greater_than(0) }
    it { is_expected.to validate_absence_of(:period) }
    it { should allow_value('Income').for(:type) }
    it { should allow_value('income').for(:category) }
    it { should validate_inclusion_of(:category).in_array(categories) }
    it { should belong_to(:account) }
  end

  # describe "Custom validations" do
  #   let (:income) { build :valid_income, amount: Money.new(10, :cop)}
  # end

  describe "AASM validations" do
    describe "with valid income" do
      let (:income) { build :valid_income}

      it "should reconcile" do
        expect(income).to have_state(:created)
        expect(income).to allow_event(:reconcile)
        expect(income).to transition_from(:created).to(:reconciled).on_event(:reconcile)
        expect(income).to have_state(:reconciled)
        expect(income).not_to have_state(:created)
      end
    end
  end

  describe "transaction in account" do
    let (:income) { build :valid_income}
    it "should increment account's balance" do
      old_balance = income.account.balance
      income.reconcile!
      expect(income.account.balance).to eq(old_balance + income.amount)
    end
  end

end
