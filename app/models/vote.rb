class Vote < ActiveRecord::Base
  belongs_to :comment ,inverse_of: :votes
  validates :comment , :email , :up , presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                              message: "Enter Valid Email" }
end
