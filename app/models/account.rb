class Account < ApplicationRecord
  # Initialize enum fields
  as_enum :type, [:current, :savings], map: :string, source: :type
  as_enum :provider, [:plain], map: :string, source: :provider

  # disable STI
  self.inheritance_column = :_type_disabled

  # Set up relations
  belongs_to :user
  belongs_to :currency

  has_many :expenses_transactions, class_name: 'Transaction', as: :source, dependent: :restrict_with_error
  has_many :incomes_transactions, class_name: 'Transaction', as: :destination, dependent: :restrict_with_error

  has_many :balances, class_name: 'Balance', as: :owner, dependent: :destroy
  has_many :incomes, class_name: 'Income', as: :owner, dependent: :destroy
  has_many :expenses, class_name: 'Expense', as: :owner, dependent: :destroy

  # Validate
  validates :name, presence: true, uniqueness: { scope: [:user, :currency] }
  validates :type, presence: true
  validates :provider, presence: true
  validates :user, presence: true
  validates :currency, presence: true

  def transactions
    self.expenses_transactions + self.incomes_transactions
  end

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
