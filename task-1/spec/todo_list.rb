require 'bundler/setup'
require 'rspec/expectations'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(items) }
  let(:items)               { [] }
  let(:item_description)    { "Buy toilet paper" }
  let(:another_item_description)  { "Read book" }
  let(:yet_another_item_description)  { "Alabama" }
  it { should be_empty }

  it "should raise an exception when nil is passed to the constructor" do
    expect { TodoList.new(nil) }.to raise_error(IllegalArgument)
  end

  it "should have size of 0" do
    list.size.should == 0
  end

  it "should accept an item" do
    list << item_description
    list.should_not be_empty
  end

  it "should add the item to the end" do
    list << item_description
    list.last.to_s.should == item_description
  end

  it "should have the added item uncompleted" do
    list << item_description
    list.completed?(0).should be_false
  end

  context "with one item" do
    let(:items)             { [item_description] }

    it { should_not be_empty }

    it "should have size of 1" do
      list.size.should == 1
    end

    it "should have the first and the last item the same" do
      list.first.to_s.should == list.last.to_s
    end

    it "should not have the first item completed" do
      list.completed?(0).should be_false
    end

    it "should change the state of a completed item" do
      list.complete(0)
      list.completed?(0).should be_true
    end
  end

  context "with many items" do
    let(:items)             { [item_description, another_item_description, yet_another_item_description] }

    it "should return completed items" do
      for i in (0...list.size) do
        list.completed.size.should == i
        list.complete(i)
      end
    end

    it "should return uncompleted items" do
      for i in (0...list.size) do
        list.uncompleted.size.should == (list.size - i)
        list.complete(i)
      end
    end

    it "should remove individual items" do
      expect {list.remove(list.size)}.to raise_error(IndexOutOfBounds)
      removed = list.first.to_s
      list.remove(0)
      list.first.to_s.should_not == removed
    end

    it "should remove all completed items" do
      size_before = list.size
      list.complete(0)
      list.remove_completed
      list.size.should == size_before - 1
    end

    it "should revert order of two items" do
      first = list.item(0)
      second = list.item(1)
      list.revert(0, 1)
      second.should == list.item(0)
      first.should == list.item(1)
      expect {list.revert(0, list.size)}.to raise_error(IndexOutOfBounds)
      expect {list.revert(list.size, 0)}.to raise_error(IndexOutOfBounds)
    end

    it "should revert order of all items" do
      items = []
      for i in (0...list.size) do
        items.push(list.item(i))
      end
      list.revert
      for i in (0...list.size) do
        items[items.size - i - 1].to_s.should == list.item(i).to_s
      end
    end

    it "should toggle state of an item" do
      expect {list.toggle(list.size)}.to raise_error(IndexOutOfBounds)
      2.times do
        list.toggle(0)
        list.completed?(0).should be_true
        list.toggle(0)
        list.completed?(0).should be_false
      end
    end

    it "should set state of item to uncompleted" do
      list.complete(0)
      expect {list.uncomplete(list.size)}.to raise_error(IndexOutOfBounds)
      list.uncomplete(0)
      list.completed?(0).should be_false
    end

    it "should change the description of an item" do
      list.first.to_s.should_not == another_item_description
      list.first.description = another_item_description
      list.first.to_s.should == another_item_description
    end

    it "should sort items by name" do
      list.sort
      for i in (0...(list.size - 1)) do
        list.item(i).to_s.should <= list.item(i + 1).to_s
      end
    end

    it "should convert the list to text with the following format:\n- [ ] Uncompleted item\n- [x] Completed item" do
      list.complete(1)
      list.to_s.should == "- [ ] #{item_description}\n- [x] #{another_item_description}\n- [ ] #{yet_another_item_description}"
    end

  end

end
