require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub! }
  let(:item)                { Struct.new(:title,:description,:complete).new(title,description,false) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    stub(database).get_todo_item(0) { item }
    mock(database).complete_todo_item(item,true) { item.complete = true; true }
    mock(database).complete_todo_item(item,false) { item.complete = false; true }

    list.toggle_state(0)
    item.complete.should be_true
    list.toggle_state(0)
    item.complete.should be_false
  end

  it "should fetch the first item from the DB" do
    stub(database).items_count { 1 }
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    stub(database).items_count { 0 }
    list.first.should == nil
  end

  it "should fetch the last item for the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end

  it "should return nil for outmost items if the DB is empty" do
    stub(database).items_count { 0 }

    list.first.should == nil
    list.last.should == nil
  end

  it "should raise an exception when changing the item state if the item is nil" do
    mock(database).get_todo_item(1) { nil }

    expect{ list.toggle_state(1) }.to raise_error(NilItem) 
  end

  it "shouldn't accept a nil item" do
    dont_allow(database).add_todo_item(nil)

    list << nil
  end

  context "with too short title of the item" do
    let(:short_title_item)                { Struct.new(:title,:description,:complete).new(short_title,description,false) }
    let(:short_title)                     { "short" }

    it "shouldn't accept an item with too short title" do
      dont_allow(database).add_todo_item(short_title_item)
      
      list << short_title_item
    end
  end

  context "with missing description of the item" do
    let(:item_without_description)        { Struct.new(:title,:complete).new(title,false) }

    it "should accept an item with missing description" do
      mock(database).add_todo_item(item_without_description) { true }

      list << item_without_description
    end
  end

  context "with social network" do
    subject(:list)                        { TodoList.new(db: database, network: social_network) }
    let(:social_network)                  { stub! }

    it "should notify social network if an item is added" do
      mock(social_network).notify { true }

      list << item
    end

    it "should notify social network if an item is completed" do
      stub(database).get_todo_item(0) { item }
      mock(database).complete_todo_item(item,true) { item.complete = true; true }
      mock(social_network).notify { true }

      list.toggle_state(0)
    end

    context "with missing title of the item" do
      let(:item_without_title)            { Struct.new(:description,:complete).new(description,false) }
      
      it "shouldn't notify social network if the title of the item is missing" do
        stub(database).get_todo_item(1) { item_without_title }
        dont_allow(social_network).notify

        list << item_without_title
      end
    end

    context "with missing description of the item" do
      let(:item_without_description)      { Struct.new(:title,:complete).new(title,false) }

      it "should notify social network if the body of the item is missing" do
        mock(database).add_todo_item(item_without_description) { true }
        mock(social_network).notify { true }

        list << item_without_description
      end
    end

    context "with title of the item longer than 255 characters" do
      let(:title)                         { 'a' * 256 }

      it "should cut the title when notifying social network when adding an item" do
        stub(database).get_todo_item(1) { item }
        mock(social_network).notify { true }

        item.title.size.should == 256
        list << item
        item.title.size.should == 255
      end

      it "should cut the title when notifying social network when completing an item" do
        stub(database).get_todo_item(0) { item }
        mock(database).complete_todo_item(item,true) { item.complete = true; true }
        mock(social_network).notify { true }

        item.title.size.should == 256
        list.toggle_state(0)
        item.title.size.should == 255
      end
    end
  end

end
