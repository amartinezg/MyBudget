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

require 'rails_helper'

RSpec.describe Account, type: :model do

  describe "#balance" do
    let (:account) { build :cash_with_balance}
    it "should be monetized" do
      expect(account).to monetize(:balance)
    end
  end

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:type) }

    it { is_expected.to validate_inclusion_of(:type).in_array(['savings', 'credit', 'cash']) }
  end

  # context "when name is empty" do
  #   let (:account) { build :cash_withouth_name}
  #   it "should not be valid" do
  #     expect(account).to be_invalid
  #   end

  #   it "should not save" do
  #     byebug

  #     expect(account.save).to be_false
  #   end
  # end

  # context "when type is empty" do
  #   let (:account) { build :cash_with_balance}

  #   it "should not be valid" do
  #     expect(account).to be_invalid
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end

  # context "when balance_cents is empty" do
  #   let (:account) { build :cash_with_balance}

  #   it "should not be valid" do
  #     expect(account).to be_invalid
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end

  # context "when currency is empty" do
  #   let (:account) { build :cash_with_balance}

  #   it "should not be valid" do
  #     expect(account).to be_invalid
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end
end
