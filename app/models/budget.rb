class Budget < ApplicationRecord
  # Set up relations
  belongs_to :user
  belongs_to :currency
  belongs_to :default_account, class_name: 'Account', optional: true

  has_many :periods, dependent: :restrict_with_error
  has_many :transactions, through: :periods, dependent: :restrict_with_error

  has_many :balances, class_name: 'Balance', as: :timeperiod, dependent: :destroy
  has_many :incomes, class_name: 'Income', as: :timeperiod, dependent: :destroy
  has_many :expenses, class_name: 'Expense', as: :timeperiod, dependent: :destroy

  has_and_belongs_to_many :targets

  # Validation rules
  validates :name, presence: true, uniqueness: { scope: [:user, :currency] }
  validates :user, presence: true
  validates :currency, presence: true
  validates :active, inclusion: { in: [ true, false ] }

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
