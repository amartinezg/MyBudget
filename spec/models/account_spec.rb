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
  let (:account) { build :cash_with_balance}

  describe "#balance" do
    it "should be monetized" do
      expect(account).to monetize(:prices)
    end
  end

  # context "when name is empty" do
  #   it "should not be valid" do
  #     expect(account.valid?).to be_false
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end

  # context "when type is empty" do
  #   it "should not be valid" do
  #     expect(account.valid?).to be_false
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end

  # context "when balance_cents is empty" do
  #   it "should not be valid" do
  #     expect(account.valid?).to be_false
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end

  # context "when currency is empty" do
  #   it "should not be valid" do
  #     expect(account.valid?).to be_false
  #   end

  #   it "should not save" do
  #     expect(account.save).to be_false
  #   end
  # end
end
