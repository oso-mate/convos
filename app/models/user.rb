class User < ActiveRecord::Base

  validates :user_name, uniqueness: { case_sensitive: false }

end