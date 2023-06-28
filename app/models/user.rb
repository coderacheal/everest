class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :categories
  has_many :expenses
  has_one_attached :avatar

  validates :name, length: { maximum: 50 }
end
