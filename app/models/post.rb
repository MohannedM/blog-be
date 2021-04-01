class Post < ApplicationRecord
	validates :title, presence: true, length: { minimum:3 }
    validates :body, presence: true, length: { minimum:3 }

    belongs_to :user
    has_many :comments
	acts_as_taggable_on :tags

	# delete post

	scope :delete_old_posts, lambda { where('created_at <= :time_to_delete', time_to_delete: Time.now - 1.days) }
end
