class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable ,:registerable ,:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  has_many :votes ,inverse_of: :user
end
