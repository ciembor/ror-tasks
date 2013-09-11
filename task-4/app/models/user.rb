class User < ActiveRecord::Base
  has_many :todo_lists, dependent: :destroy
  has_many :todo_items, through: :todo_lists

  validates :name, :presence => true, :length => {:maximum => 20 }
  validates :surname, :presence => true, :length => {:maximum => 30 }
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on =>:create}
  validates :terms_of_service, :acceptance => true
  validates :password, :presence => true, :confirmation => true, :length => {:minimum => 10}
  validates :failed_login_count, :presence => true
end