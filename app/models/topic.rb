class Topic < ActiveRecord::Base
  has_many :comments ,dependent: :destroy  ,inverse_of: :topic
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
