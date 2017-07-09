class Currency < ApplicationRecord
  # Set up relations
  belongs_to :user

  has_many :balances, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :expenses, dependent: :destroy

  has_many :budgets, dependent: :restrict_with_error
  has_many :accounts, dependent: :restrict_with_error

  has_many :transactions, through: :budgets, dependent: :restrict_with_error
  has_many :periods, through: :budgets, dependent: :restrict_with_error

  # Validation rules
  validates :name, presence: true, uniqueness: { scope: :user }
  validates :symbol, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true

  def incomes_balance
    self.incomes.first ? self.incomes.first.value : nil
  end

  def expenses_balance
    self.expenses.first ? self.expenses.first.value : nil
  end

  def balance
    self.balances.first ? self.balances.first.value : nil
  end
end
