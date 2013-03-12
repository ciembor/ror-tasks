class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(params=[])
    raise IllegalArgument unless params[:db]
    @db = params[:db]
    @network = params[:network] if params[:network]
  end

  def empty?
    @db.items_count == 0 ? true : false
  end

  def size
    @db.items_count
  end

  def <<(item)
    unless item.nil? or not defined? item.title or item.title.size < 6
      truncate_item(item)
      @db.add_todo_item(item) 
      self.notify
    end
  end

  def first
    @db.get_todo_item(0) if @db.items_count != 0
  end

  def last
    @db.get_todo_item(@db.items_count - 1) if @db.items_count != 0
  end

  def toggle_state(index)
    item = @db.get_todo_item(index)
    unless item.nil?
      truncate_item(item)
      @db.complete_todo_item(item, item.complete ? false : true)
      self.notify
    else
      raise NilItem
    end
  end

  def notify
    @network.notify if @network
  end

  def truncate_item(item)
    item.title = item.title[0...255]
  end

end
