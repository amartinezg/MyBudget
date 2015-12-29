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

require 'rails_helper'

RSpec.describe Account, type: :model do

  describe "#balance" do
    let (:account) { build :cash_with_balance}
    it "should be monetized" do
      expect(account).to monetize(:balance).with_currency(:cop)
    end
  end

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_presence_of(:balance_cents) }
    it { is_expected.to validate_inclusion_of(:type).in_array(['savings', 'credit', 'cash']) }
    it { should validate_uniqueness_of(:name).
      scoped_to(:type, :balance_currency).with_message('Account already exists') }
    it { should have_many(:movements) }
  end

end
