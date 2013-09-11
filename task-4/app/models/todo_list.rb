class TodoList < ActiveRecord::Base
  belongs_to :user
  has_many :todo_items

  has_many :todo_items
  validates :title, :presence => true
  validates :user_id, :presence => true
end