class Convo < ActiveRecord::Base

  validates :sender_user_id, presence: true
  validates :recipient_user_id, presence: true
  validates :subject_line, presence: true, length: { maximum: 140 }
  validates :body, presence: true
  validates :state, inclusion: { in: %w(new read) }

end