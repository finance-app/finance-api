class Transaction < ApplicationRecord
  attr_accessor :creating

  as_enum :type, [:fixed, :flexible, :discretionary], map: :string, source: :type

  # Enable versioning
  has_paper_trail

  # disable STI
  self.inheritance_column = :_type_disabled

  # Set up validators
  validate :validate_source_destination
  validates :value,  numericality: { greater_than: 0 }, uniqueness: { scope: [:source_id, :date, :destination_id, :period_id] }
  validates :type, :presence => true

  # Set up relations
  belongs_to :period
  belongs_to :user
  belongs_to :budget
  belongs_to :source_currency, :class_name => 'Currency'
  belongs_to :destination_currency, :class_name => 'Currency'
  belongs_to :transaction_category
  belongs_to :source, polymorphic: true, optional: true
  belongs_to :destination, polymorphic: true, optional: true

  after_create do
    # If we create, we don't want to trigger update trigger
    self.creating = true
    self.update_all_balances(self.value)
  end

  after_destroy do
    self.update_all_balances(self.value*-1)
  end

  after_update do
    unless self.creating
      old = self.paper_trail.previous_version
      if old
        old.update_all_balances(old.value*-1)
        self.update_all_balances(self.value)
      end
    end
  end

  def update_all_balances(value)
    # Fetch existing balances from database
    balances = self.balances
    # Convert them to array, so we don't have to select on database multiple times
    balances_array = balances.to_a

    # Check which balances does not exist and needs to be created
    balances_to_create = self.balances_hash.delete_if do |a|
      balances_array.select do |b|
        (a[:type] == b.type &&
        a[:transaction_type] == b.transaction_type &&
        a[:date] == b.date &&
        a[:owner_id] == b.owner_id &&
        a[:owner_type] == b.owner_type &&
        a[:timeperiod_id] == b.timeperiod_id &&
        a[:timeperiod_type] == b.timeperiod_type)
      end.any?
    end

    # Create missing balances
    if balances_to_create.any?
      BalanceBase.import(balances_to_create)
    end

    # Update existing balances
    balances.each do |balance|
      self.update_balance(value, balance)
    end
  end

  def update_balance(value, balance)
    case balance
    when Balance
      # Expense
      if self.source.is_a?(Account) or self.destination.is_a?(Target)
        balance.value -= value
      # Income
      else
        balance.value += value
      end
    when Income
      if self.destination.is_a?(Account) or self.source.is_a?(Target)
        balance.value += value
      end
    when Expense
      if self.source.is_a?(Account) or self.destination.is_a?(Target)
        balance.value -= value
      end
    end

    if balance.value == 0
      balance.destroy!
    else
      balance.save!
    end
  end

  def account
    self.source.is_a?(Account) ? self.source : self.destination
  end

  def target
    self.source.is_a?(Account) ? self.destination : self.source
  end

  def budget_id
    self.period.budget_id
  end

  def transaction_type
    (self.source.is_a?(Account) or self.destination.is_a?(Target)) ? 'expense' : 'income'
  end

  def validate_source_destination
    unless source or destination
      errors.add(:source_id, "or destination needs to be specified")
      errors.add(:destination_id, "or source needs to be specified")
    end
  end

  def currency
    if self.source_currency == self.destination_currency
      self.source_currency
    else
      nil
    end
  end

  # Returns actual balances from database
  def balances
    base = BalanceBase.where(date: self.date, currency: self.currency)
    first = true
    result = nil

    # Type
    [self.type, nil].collect do |type|
      # Owner
      [self.source, self.destination, self.transaction_category, nil].collect do |owner|
        # Timeperiod
        [self.period, self.budget, nil].collect do |timeperiod|
          if first
            first = false
            result = base.where(owner: owner, timeperiod: timeperiod, transaction_type: type)
          else
            result = result.or(base.where(owner: owner, timeperiod: timeperiod, transaction_type: type))
          end
        end
      end
    end

    result.includes(:currency)
  end

  # Returns balances schema, which transaction should have associated and stored in database
  def balances_hash
    currency_id = self.currency.id
    transaction_type = self.transaction_type.capitalize
    # Type
    [self.type.to_s, nil].collect do |type|
      # Owner
      [self.source, self.destination, self.transaction_category, nil].collect do |owner|
        # Timeperiod
        [self.period, self.budget, nil].collect do |timeperiod|
          # Subclass
          ['Balance', transaction_type].collect do |subclass|
            {
              currency_id: currency_id,
              date: self.date,
              type: subclass,
              value: transaction_type == 'Income' ? self.value : self.value*-1,
              owner_id: owner ? owner.id : nil,
              owner_type: owner ? owner.class.to_s : nil,
              timeperiod_id: timeperiod ? timeperiod.id : nil,
              timeperiod_type: timeperiod ? timeperiod.class.to_s : nil,
              transaction_type: type,
            }
          end
        end
      end
    end.flatten.uniq
  end
end
