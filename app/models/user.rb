class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  # パスワードリセット機能無効化のため :recoverable を削除
  has_many :sakes, dependent: :destroy

  validates :name, presence: true
end
