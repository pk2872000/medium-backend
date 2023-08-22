class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :saved_posts
  has_many :saved_by_users, through: :saved_posts, source: :user

  before_save :calculate_reading_time

  has_one_attached :avatar
  has_many :lists

  has_many :votes
  
  enum status: {
    draft: 0,
    unpublished: 1,
    published: 2
  }

  scope :published_posts, -> { where(status: :published) }
  scope :draft_posts, -> { where(status: :draft) }
  scope :unpublished_posts, -> { where(status: :unpublished) }

 
end
