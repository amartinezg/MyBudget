# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Account.create(name: "Dosh", type: "cash", balance: Money.new(5560000))
Account.create(name: "Mastercard credit card", type: "credit", balance: Money.new(-60000000))
Account.create(name: "US MasterCard credit card", type: "credit", :balance_currency => "USD", balance: Money.new(-20000, "USD"))
Account.create(name: "Savings Payroll", type: "savings", balance: Money.new(120000000))