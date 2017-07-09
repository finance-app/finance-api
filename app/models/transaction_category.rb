class TransactionCategory < ApplicationRecord
  # Set up relations
  belongs_to :user

  has_many :transactions, dependent: :restrict_with_error

  has_many :balances, class_name: 'Balance', as: :owner, dependent: :destroy
  has_many :incomes, class_name: 'Income', as: :owner, dependent: :destroy
  has_many :expenses, class_name: 'Expense', as: :owner, dependent: :destroy

  # Validate
  validates :name, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true

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
