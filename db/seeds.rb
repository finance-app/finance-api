# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
User.destroy_all
puts "Removed all existing users"

demo = User.create!(name: 'Demo User', email: 'demo@demo', password: 'demo', password_confirmation: 'demo')
puts "Created demo user: login: 'demo@demo', password: 'demo'"

User.create!(name: 'Empty User', email: 'empty@demo', password: 'demo', password_confirmation: 'demo')
puts "Created empty user: login: 'empty@demo', password: 'demo'"



Currency.destroy_all
puts "Removed all existing currencies"

eur = Currency.create!(name: 'EUR', symbol: '€', user: demo)
pln = Currency.create!(name: 'PLN', symbol: 'Zł', user: demo)
puts "Created #{Currency.count} currencies"



Account.destroy_all
puts "Removed all existing accounts"

current_account = Account.create!(name: 'Current Account', comment: 'Main account', user: demo, currency: eur)
savings_account = Account.create!(name: 'Savings Account', type: 'savings', user: demo, currency: eur)
foreign_account = Account.create!(name: 'Savings Foreign Account', type: 'savings', user: demo, currency: pln)

puts "Created #{Account.count} accounts"



Transaction.destroy_all
puts "Removed all existing transactions"

TransactionCategory.destroy_all
puts "Removed all existing transaction categories"

groceries = TransactionCategory.create!(name: 'Groceries', user: demo)
transport = TransactionCategory.create!(name: 'Transport', user: demo, comment: 'Public transport mostly')
salary = TransactionCategory.create!(name: 'Salary', user: demo)
recycling = TransactionCategory.create!(name: 'Recycling', user: demo)

puts "Created #{TransactionCategory.count} categories"



Target.destroy_all
puts "Removed all existing transaction categories"

public_transport = Target.create!(name: 'Public transport company', default_expense_transaction_category: transport, user: demo)
my_work = Target.create!(name: 'My working company', default_income_transaction_category: salary, user: demo)
groceries_store = Target.create!(name: 'My favourite groceries store', default_expense_transaction_category: groceries, user: demo, favourite: true)

puts "Created #{Target.count} targets"



Budget.destroy_all
puts "Removed all existing budgets"

paris = Budget.create!(name: 'Paris', currency: eur, user: demo, default_account: current_account)
cracow = Budget.create!(name: 'Cracow', currency: pln, user: demo)

puts "Created #{Budget.count} budgets"



Period.destroy_all
puts "Removed all existing periods"

cracow_period = Period.create!(budget: cracow, comment: 'Trip to Cracow on holidays', start_date: '2016-12-15', end_date: '2016-12-24', user: demo)
paris_period = Period.create!(budget: paris, start_date: '2017-05-29', end_date: '2017-06-28', user: demo)
current_period = Period.create(budget: paris, start_date: '2017-06-28', user: demo)

puts "Created #{Period.count} periods"


Transaction.create!(user: demo, budget: paris, period: paris_period, transaction_category: salary, value: 1125.63, source: my_work, destination: current_account, date: '2017-05-30', source_currency: paris.currency, destination_currency: current_account.currency, type: 'fixed')
Transaction.create!(user: demo, budget: paris, period: paris_period, transaction_category: groceries, value: 15.25, source: current_account, destination: groceries_store, date: '2017-06-01', source_currency: paris.currency, destination_currency: current_account.currency, type: 'flexible')
Transaction.create!(user: demo, budget: paris, period: paris_period, transaction_category: groceries, value: 12.22, source: current_account, destination: groceries_store, date: '2017-06-03', source_currency: paris.currency, destination_currency: current_account.currency, type: 'flexible')
Transaction.create!(user: demo, budget: paris, period: paris_period, transaction_category: recycling, value: 5.32, source: groceries_store, destination: current_account, date: '2017-06-12', source_currency: paris.currency, destination_currency: current_account.currency, type: 'flexible')
Transaction.create!(user: demo, budget: paris, period: current_period, transaction_category: salary, value: 1125.63, source: my_work, destination: current_account, date: '2017-06-30', source_currency: paris.currency, destination_currency: current_account.currency, type: 'fixed')
Transaction.create!(user: demo, budget: paris, period: current_period, transaction_category: transport, value: 162, source: current_account, destination: public_transport, date: '2017-07-05', source_currency: paris.currency, destination_currency: current_account.currency, type: 'fixed')
Transaction.create!(user: demo, budget: paris, period: current_period, transaction_category: groceries, value: 35.32, source: savings_account, destination: groceries_store, date: '2017-07-15', source_currency: paris.currency, destination_currency: current_account.currency, type: 'flexible')
Transaction.create!(user: demo, budget: cracow, period: cracow_period, transaction_category: groceries, value: 5.32, source: foreign_account, destination: groceries_store, date: '2016-12-20', source_currency: cracow.currency, destination_currency: foreign_account.currency, type: 'flexible')
puts "Created #{Transaction.count} transactions"
