class Post < ActiveRecord::Base
	has_many :comments
 	has_many :likes
 	validates :body, :presence => true
  	validates :body, :uniqueness => true
end
