class Post < ActiveRecord::Base
	has_many :comments
 	has_many :likes 	
  belongs_to :users
 	validates :body, :presence => true
  validates :body, :uniqueness => true

  

  
end
