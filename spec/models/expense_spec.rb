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

RSpec.describe Expense, type: :model do
  describe "ActiveModel validations" do
    subject { build :valid_expense }

    it { is_expected.to validate_presence_of(:date) }
    it { should validate_numericality_of(:amount_cents).is_less_than(0) }
    it { is_expected.to validate_absence_of(:period) }
    it { is_expected.to allow_value('Expense').for(:type) }
    it { is_expected.not_to validate_inclusion_of(:type).in_array(%w[Income Budget])}
  end

  describe "AASM validations" do
    describe "with valid expense" do
      let (:expense) { build :valid_expense}

      it "should reconcile" do
        expect(expense).to have_state(:created)
        expect(expense).to allow_event(:reconcile)
        expect(expense).to transition_from(:created).to(:reconciled).on_event(:reconcile)
        expect(expense).to have_state(:reconciled)
        expect(expense).not_to have_state(:created)
      end
    end
  end

  describe "transaction in account" do
    let (:expense) { build :valid_expense}
    it "should increment account's balance" do
      old_balance = expense.account.balance
      expense.reconcile!
      expect(expense.account.balance).to eq(old_balance + expense.amount)
    end
  end

  describe "private instance methods" do
    let (:expense) { build :valid_expense}
    let (:credit_expense) { build :credit_card_expense}
    let (:invalid_expense) { build :valid_expense, amount_cents: 100}
    let (:invalid_credit_expense) { build :credit_card_expense, amount_cents: -100}

    it { expect(expense.send(:invalid_amount?)).to be false }
    it { expect(credit_expense.send(:invalid_amount?)).to be false }
    it { expect(invalid_expense.send(:invalid_amount?)).to be true }
    it { expect(invalid_credit_expense.send(:invalid_amount?)).to be true }
  end

end
