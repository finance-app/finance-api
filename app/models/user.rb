class User < ApplicationRecord
  has_secure_password
  has_paper_trail

  has_many :budgets, dependent: :destroy
  has_many :currencies, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :transaction_categories, dependent: :destroy
  has_many :targets, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
