class Target < ApplicationRecord
  # Set up relations
  belongs_to :user
  belongs_to :default_income_transaction_category, class_name: 'TransactionCategory', optional: true
  belongs_to :default_expense_transaction_category, class_name: 'TransactionCategory', optional: true

  has_many :expenses_transactions, class_name: 'Transaction', as: :source, dependent: :restrict_with_error
  has_many :incomes_transactions, class_name: 'Transaction', as: :destination, dependent: :restrict_with_error

  has_many :balances, class_name: 'Balance', as: :owner, dependent: :destroy
  has_many :incomes, class_name: 'Income', as: :owner, dependent: :destroy
  has_many :expenses, class_name: 'Expense', as: :owner, dependent: :destroy

  # Validation rules
  validates :name, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true
  validates :favourite, inclusion: { in: [ true, false ] }

  def transactions
    self.expenses_transactions + self.incomes_transactions
  end

  def incomes_balance
    self.incomes.map(&:value).inject(:+)
  end

  def expenses_balance
    self.expenses.map(&:value).inject(:+)
  end

  def balance
    self.balances.map(&:value).inject(:+)
  end
end
