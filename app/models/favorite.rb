class Favorite < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :use_case
end
