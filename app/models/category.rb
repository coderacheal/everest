class Category < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :expenses

  validates :name, presence: true, length: { maximum: 50 }
  validates :limit, numericality: { less_than: 1_000_000 }
end
