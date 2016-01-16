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

  describe "AASM validations" do
    describe "with valid budget" do
      let (:budget) { build :valid_budget}

      it "should run when period belongs to current month" do
        allow(Date).to receive_messages(:today => Time.now.beginning_of_month.next_month.to_date)
        expect(budget).to allow_event(:run)
        expect(budget).not_to allow_event(:close)
        expect(budget).to transition_from(:created).to(:running).on_event(:run)
        expect(budget).to have_state(:running)
        expect(budget).not_to have_state(:created)
        expect(budget).not_to have_state(:closed)
      end

      it "should not run when period does not belong to current month" do
        expect(budget).not_to allow_event(:run)
        expect(budget).not_to allow_event(:close)
        expect(budget).to have_state(:created)
        expect(budget).not_to have_state(:running)
        expect(budget).not_to have_state(:closed)
        expect(budget).to_not allow_transition_to(:running)
        expect(budget).to_not allow_transition_to(:closed)
      end
    end

    describe "with expired budget" do
      let (:expired_budget) { build :expired_budget}

      it "should close when period belongs to last month" do
        expect(expired_budget).to have_state(:running)
        expect(expired_budget).to allow_event(:close)
        expect(expired_budget).to transition_from(:running).to(:closed).on_event(:close)
        expect(expired_budget).not_to have_state(:created)
        expect(expired_budget).to have_state(:closed)
        expect(expired_budget).not_to allow_event(:run)
      end

      it "should not close when period does not belongs to last month" do
        allow(Date).to receive_messages(:today => Time.now.beginning_of_month.last_month.to_date)
        expect(expired_budget).to_not allow_transition_to(:closed)
        expect(expired_budget).to have_state(:running)
        expect(expired_budget).not_to have_state(:created)
        expect(expired_budget).not_to have_state(:closed)
      end
    end
  end

end
