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
  validates_inclusion_of :type, in: %w(savings credit cash)
  validates_uniqueness_of :name, scope: [:type, :balance_currency], message: "Account already exists"

  XML_ATTRS = {date: "FECHA", category: "CATEGORIA", sub_category: "SUB_CATEGORIA", notes: "DESCRIPCIÓN"}

  ["increment", "decrement"].each do |action|
    define_method("#{action}_balance") do |amount|
      self.send("#{action}!".to_sym, :balance_cents, amount.cents)
    end
  end

  def load_movements_from_xml(path)
    load_xml(path)
    @xml.xpath("//Movimiento").map do |movement|
      mov = create_instance(movement.xpath("VALOR"))
      XML_ATTRS.each do |key, value|
        mov.send("#{key}=".to_sym, movement.xpath(value).text)
      end
      mov.reconcile!
    end
  end

  private
  def load_xml(path)
    @xml = File.open(path) { |f| Nokogiri::XML(f) }
  end

  def create_instance(amount)
    amount = Money.new(amount.text.gsub(/[.,]/,""), balance_currency)
    attributes = {amount: amount, account: self}
    amount > 0 ? Income.new(attributes) : Expense.new(attributes)
  end
end
