class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(params=[])
  	raise IllegalArgument unless params[:db]
  	@db = params[:db]
  end

  def empty?
  	@db.items_count == 0 ? true : false
  end

  def size
  	@db.items_count
  end

  def <<(item)
  	@db.add_todo_item(item) if item.title != ""
  end

  def first
  	@db.get_todo_item(0)
  end

  def last
  	@db.get_todo_item(@db.items_count - 1)
  end

  def toggle_state(index)
  	item = @db.get_todo_item(index)
  	# @db.complete_todo_item(item, !item.completed?)
  end

end
