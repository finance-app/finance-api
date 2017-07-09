class BalanceBase < ApplicationRecord
  # Set up relations
  belongs_to :timeperiod, polymorphic: true, optional: true
  belongs_to :owner, polymorphic: true, optional: true
  belongs_to :currency, required: true

  # Validation rules
  validates :currency, presence: true, uniqueness: { scope: [:timeperiod, :owner, :date, :type, :transaction_type] }
  validates :value, presence: true, numericality: true, format: { :with => /\d{0,8}(\.\d{1,4})?/ }

  # Default sorted scope
  default_scope { order(date: :asc) }
end
