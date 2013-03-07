class TodoList

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
  	raise IllegalArgument if items.nil?
  	@items = items
  	@completed = []
  end

  def empty?
  	@items.empty?
  end

  def size
  	@items.size
  end

  def <<(item)
  	@items.push(item)
  end

  def first
  	@items.last
  end

  def last
  	@items.last
  end

  def completed?(index)
  	true if @completed.include?(index)
  end

  def complete(index)
  	@completed.push(index)
  end

end
