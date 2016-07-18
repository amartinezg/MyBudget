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
    it { is_expected.to validate_inclusion_of(:type).in_array(['savings', 'credit', 'cash', 'inversion']) }
    it { should validate_uniqueness_of(:name).
      scoped_to(:type, :balance_currency).with_message('Account already exists') }
    it { should have_many(:movements) }
    it { should have_db_index([:name, :type, :balance_currency])}
  end

  describe "public instance methods" do
    let (:account) { build :cash_with_balance}

    context "responds to its methods" do
      it { expect(account).to respond_to(:is_credit?) }
      it { expect(account).to respond_to(:is_not_credit?) }
      it { expect(account).to respond_to(:increment_balance).with(1).argument }
      it { expect(account).to respond_to(:load_movements_from_xml).with(1).argument }
    end

    context "#load_movements_from_xml" do
      context "when xml is not valid" do
        path = Rails.root.join('spec', 'files', 'invalid_xml_file.xml')
        it { expect { account.load_movements_from_xml(path) }.to raise_error(StandardError) }
        it "does not affect account's balance" do
          balance = account.balance
          account.load_movements_from_xml(path) rescue nil
          expect(balance).to eq(account.balance)
        end
      end

      context "when xml is valid" do
        path = Rails.root.join('spec', 'files', 'valid_xml_file.xml')
        it "should increment number of movements" do
          account.load_movements_from_xml(path)
          expect(account.movements.count).to be(4)
          expect(account.movements.expenses.count).to be(3)
          expect(account.movements.incomes.count).to be(1)
        end

        it "should increment account's balance" do
          balance = account.balance
          account.load_movements_from_xml(path)
          new_balance = balance + account.movements.map(&:amount).inject(:+)
          expect(account.balance).to eq(new_balance)
        end
      end
    end
  end
end
