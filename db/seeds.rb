# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def self.period
  Time.now.beginning_of_month.to_date
end

def self.random_credit_money
  Random.rand(10000.0..100000.0)*100
end

def self.random_debit_money
  Random.rand(-100000.0..-10000.0)*100
end

Account.create(name: "Dosh", type: "cash", balance: Money.new(random_credit_money))
Account.create(name: "Mastercard credit card", type: "credit", balance: Money.new(random_debit_money))
Account.create(name: "US MasterCard credit card", type: "credit", :balance_currency => "USD", balance: Money.new(random_debit_money, "USD"))
Account.create(name: "Savings Payroll", type: "savings", balance: Money.new(random_credit_money))

a = Budget.create(category: "income", sub_category: "salary", period: period, amount: Money.new(random_credit_money))
p a.valid?
p a.errors
Budget.create(category: "transport", sub_category: "metro", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "transport", sub_category: "cab", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "transport", sub_category: "bus", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "home", sub_category: "rent", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "utilities", sub_category: "EPM", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "utilities", sub_category: "UNE", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "utilities", sub_category: "cellphone", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "utilities", sub_category: "cable", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "food", sub_category: "groceries", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "food", sub_category: "restaurant", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "food", sub_category: "mecato", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "departmental", sub_category: "clothing", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "departmental", sub_category: "books", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "departmental", sub_category: "magazines", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "entertainment", sub_category: "movies", period: period, amount: Money.new(random_credit_money))
Budget.create(category: "entertainment", sub_category: "sports", period: period, amount: Money.new(random_credit_money))