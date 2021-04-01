class User < ApplicationRecord
	validates :password, presence: true, length: { minimum:6 }
	has_many :posts
	has_secure_password

	acts_as_tagger 
end
