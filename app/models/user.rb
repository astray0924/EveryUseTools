class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :use_cases
  has_many :wows
  has_many :metoos
  has_many :favorites
  has_many :relationships, :foreign_key => "follower_id"
  has_many :reverse_relationships, :foreign_key => "followed_id", :class_name =>  "Relationship"
end
