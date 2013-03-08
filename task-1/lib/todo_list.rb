class TodoList

  class Item
  	
    def initialize(description=nil)
  	  @description = description
  	  @completed = false
  	end

    def to_s
      @description.to_s
    end

    def formated
      if @completed
        completion = "x"
      else
        completion = " "
      end
      "- [#{completion}] #{@description}"
    end

  	attr_accessor :description, :completed
  end

  # Initialize the TodoList with +items+ (empty by default).
  def initialize(items=[])
  	raise IllegalArgument if items.nil?
  	@items = []
    items.each do |item|
      @items.push Item.new(item)
    end
  end

  def empty?
  	@items.empty?
  end

  def size
  	@items.size
  end

  def <<(item)
  	@items.push(Item.new(item))
  end

  def first
  	@items.first
  end

  def last
  	@items.first
  end

  def completed?(index)
    @items[index].completed
  end

  def complete(index)
  	@items[index].completed = true
  end

  def completed
    @items.select { |item| item.completed }
  end

  def uncompleted
    @items.reject { |item| item.completed }
  end

  def remove(index)
    if (index >= 0 and index < @items.size)
      @items.delete_at(index)
    else
      raise IndexOutOfBounds
    end
  end

  def remove_completed
    @items.reject! { |item| item.completed }
  end

  def revert(*args)
    case args.size
    when 0
      @items.reverse!
    when 2
      [args[0], args[1]].each do |index|
        raise IndexOutOfBounds if (index < 0 or index >= @items.size)
      end
      tmp = @items[args[0]]
      @items[args[0]] = @items[args[1]]
      @items[args[1]] = tmp
    end
  end

  def item(index)
    @items[index]
  end

  def toggle(index)
    if (index >= 0 and index < @items.size)
      if self.completed?(index)
        self.uncomplete(index)
      else
        self.complete(index)
      end
    else
      raise IndexOutOfBounds
    end
  end

  def uncomplete(index)
    if (index >= 0 and index < @items.size)
      @items[index].completed = false
    else
      raise IndexOutOfBounds
    end
  end

  def sort
    @items.sort! { |a, b| a.description.downcase <=> b.description.downcase }
  end

  def to_s
    (@items.collect { |item| item.formated }).join("\n")
  end

end
