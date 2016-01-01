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
#

require 'rails_helper'

RSpec.describe Budget, type: :model do

  describe "#amount" do
    let (:budget) { build :valid_budget}
    it "should be monetized" do
      expect(budget).to monetize(:amount).with_currency(:cop)
    end
  end

  describe "ActiveModel validations" do
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:period) }
    it { is_expected.to validate_presence_of(:amount_cents) }
    it { should allow_value('Budget').for(:type) }
    it { is_expected.to validate_absence_of(:account).
      with_message("must be no account associated") }
    it { is_expected.to validate_absence_of(:date).
      with_message("must not have date of movement") }
  end

end
