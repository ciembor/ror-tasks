class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :title
      t.string :description
      t.datetime :due_date
      t.integer :todo_lists_id
    end
  end
end
