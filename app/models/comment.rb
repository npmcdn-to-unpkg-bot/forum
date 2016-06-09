class Comment < ActiveRecord::Base
  belongs_to :topic , inverse_of: :comments
  has_many :votes , dependent: :destroy , inverse_of: :comment
  has_many :up_votes , -> {where up: true}, class_name: 'Vote'
  has_many :down_votes , -> {where up: false}, class_name: 'Vote'
  validates :content_less ,:email ,:topic , presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                                    message: "Enter Valid Email" }
end
