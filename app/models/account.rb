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

class Account < ActiveRecord::Base
  self.inheritance_column = nil
  monetize :balance_cents, presence: true, as: "balance"
  has_many :movements

  validates_presence_of :name, :type, :balance_cents
  validates_inclusion_of :type, in: %w(savings credit cash inversion)
  validates_uniqueness_of :name, scope: [:type, :balance_currency], message: "Account already exists"

  XML_ATTRS = {date: "FECHA", category: "CATEGORIA", sub_category: "SUB_CATEGORIA", notes: "DESCRIPCION"}

  def increment_balance(amount)
    increment!(:balance_cents, amount.cents)
  end

  def is_credit?
    type == "credit"
  end

  def is_not_credit?
    !is_credit?
  end

  def load_movements_from_xml(path)
    load_xml(path)
    Account.transaction do
      Movement.transaction do
        @xml.xpath("//Movimiento").map do |movement|
          mov = create_instance(movement.xpath("VALOR"))
          XML_ATTRS.each do |key, value|
            mov.send("#{key}=".to_sym, movement.xpath(value).text)
          end
          mov.save!
          mov.reconcile!
        end
      end
    end
  end

  private
  def load_xml(path)
    @xml = File.open(path) { |f| Nokogiri::XML(f) }
  end

  def create_instance(amount)
    amount = Money.new(amount.text.gsub(/[.,]/,""), balance_currency)
    attributes = {amount_currency: balance_currency, amount: amount, account: self}
    candidates = {
      candidate_expense: Expense.new(attributes),
      candidate_income: Income.new(attributes),
      candidate_error: nil
    }
    candidates.find {|method, _| self.send method, amount}.last
  end

  def candidate_expense(amount)
    is_credit? && amount > 0 || !is_credit? && amount < 0
  end

  def candidate_income(amount)
    is_credit? && amount < 0 || !is_credit? && amount > 0
  end

  def candidate_error(amount)
    amount.nil? || amount == 0
  end

end
