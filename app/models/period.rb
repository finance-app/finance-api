class Period < ApplicationRecord
  # Set up relations
  belongs_to :budget
  belongs_to :user

  has_one :currency, through: :budget

  has_many :transactions, dependent: :restrict_with_error

  has_many :balances, class_name: 'Balance', as: :timeperiod, dependent: :destroy
  has_many :incomes, class_name: 'Income', as: :timeperiod, dependent: :destroy
  has_many :expenses, class_name: 'Expense', as: :timeperiod, dependent: :destroy

  # Validation rules
  validates :budget, presence: true
  validates :start_date, presence: true

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.start_date ||= Date.today
  end

  def name
    if self.end_date
      if self.start_date.month == self.end_date.month and self.start_date.year == self.end_date.year
        return self.start_date.strftime("%B %Y")
      else
        return (self.start_date.strftime("%B %Y") + ".." + self.end_date.strftime("%B %Y"))
      end
    else
      return (self.start_date.strftime("%B %Y") + "..Today")
    end
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

  def balance_history
    sum = 0
    data = self.balances.where(owner: nil, transaction_type: nil).map do |o|
      sum += o.value
      [o.date, sum]
    end

    {
      series: [
        {
          data: data.map{|d| d[1].to_f},
          name: 'Period balance'
        },
      ],
      labels: data.map{|d| d[0]}
    }
  end
end
