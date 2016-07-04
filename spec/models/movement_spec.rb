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

RSpec.describe Movement, type: :model do

  describe "ActiveModel validations" do
    subject { build :valid_income }

    it { is_expected.to validate_presence_of(:account) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_presence_of(:amount_cents) }
    it { should allow_value('income').for(:category) }
    it { should validate_inclusion_of(:category).in_array(categories) }
    it { should belong_to(:account) }
  end

  context "callbacks" do
    let (:income) { build :valid_income}
    it { expect(income).to callback(:restore_account_balance).before(:destroy) }
  end

  describe "#amount" do
    let (:income) { build :valid_income}
    it "should be monetized" do
      expect(income).to monetize(:amount).with_currency(:cop)
      expect(income).not_to monetize(:amount).with_currency(:usd)
      expect(income).not_to monetize(:amount).with_currency(:eur)
    end
  end

  describe "private instance methods" do
    let (:income) { build :valid_income}

    context "executes methods correctly" do
      it "Increment account' balance" do
        prev_account_balance = income.account.balance
        income.send(:increment_account_balance)
        new_account_balance = income.account.balance
        expect(prev_account_balance + income.amount).to eq(new_account_balance)
      end

      it "Restore account' balance" do
        prev_account_balance = income.account.balance
        income.send(:restore_account_balance)
        new_account_balance = income.account.balance
        expect(prev_account_balance - new_account_balance).to eq(income.amount)
      end
    end
  end
end
