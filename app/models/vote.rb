class Vote < ActiveRecord::Base
  belongs_to :comment ,inverse_of: :votes
  belongs_to :user , inverse_of: :votes
  validates :comment ,:user , :up , presence: true
end
