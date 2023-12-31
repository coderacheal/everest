class Expense < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'author_id'

  has_and_belongs_to_many :categories

  validates :name, :amount, presence: true

  validates :name, length: { maximum: 50 }
end
