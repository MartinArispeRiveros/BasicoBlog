class Comment < ActiveRecord::Base
	belongs_to :post
	#valitades :body, :presence => true
end
