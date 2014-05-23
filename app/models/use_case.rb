class UseCase < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :wow
  has_many :metoos
  has_many :favorites
end
