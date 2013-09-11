class TodoItem < ActiveRecord::Base
  belongs_to :todo_list
  
  validates :title, :presence => true, :length => {:minimum => 5, :maximum => 30}
  validates :todo_list_id, :presence => true
  validates :description, :length => {:maximum => 255}
end