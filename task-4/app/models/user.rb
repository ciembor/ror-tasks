class User < ActiveRecord::Base
  has_many :todo_lists, dependent: :destroy
  has_many :todo_items, through: :todo_lists
end