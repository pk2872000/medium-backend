class Follower < ApplicationRecord
  belongs_to :followed, class_name: 'User'

  belongs_to :follower, class_name: 'User'
  
  validate :follower_cannot_be_same_as_followed

  private

  def follower_cannot_be_same_as_followed
    errors.add(:follower_id, "can't be the same as followed") if follower_id == followed_id
  end

end
