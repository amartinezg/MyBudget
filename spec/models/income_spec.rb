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
  describe "ActiveModel validations" do
    subject { build :valid_income }

    it { is_expected.to validate_presence_of(:date) }
    it { should validate_numericality_of(:amount_cents).is_less_than(0) }
    it { is_expected.to validate_absence_of(:period) }
    it { is_expected.to allow_value('Income').for(:type) }
    it { is_expected.not_to validate_inclusion_of(:type).in_array(%w[Expense Budget])}
  end

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

  describe "private instance methods" do
    let (:income) { build :non_credit_income}
    let (:credit_income) { build :valid_income}
    let (:invalid_income) { build :non_credit_income, amount_cents: -100}
    let (:invalid_credit_income) { build :valid_income, amount_cents: 100}

    it { expect(income.send(:invalid_amount?)).to be false }
    it { expect(credit_income.send(:invalid_amount?)).to be false }
    it { expect(invalid_income.send(:invalid_amount?)).to be true }
    it { expect(invalid_credit_income.send(:invalid_amount?)).to be true }
  end

end
