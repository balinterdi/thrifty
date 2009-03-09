require File.dirname(__FILE__) + '/spec_helper'

describe "Expense" do
  before do
    Expense.all.destroy!
    @expense = Expense.gen
  end

  it "should be set the current time for spent_at if not given" do
    @expense.spent_at.day.should == Date.today.day
  end

  it "should be set the passed date for spent_at" do
    tomorrow = Date.today + 1
    Expense.gen(:spent_at => tomorrow).spent_at.day.should == tomorrow.day
  end

  describe "tagging" do
    before do
      Tag.all.destroy!
      @food_tag = Tag.gen(:food)
      @fun_tag = Tag.gen(:fun)
      @exp = Expense.first
      @exp.taggings.create(:tag => @food_tag)
    end

    it "should return true when asked if it has a certain tag it is tagged with" do
      @exp.tagged_with?(@food_tag).should == true
    end

    it "should return false when asked if it has a certain tag it is not tagged with" do
      @exp.tagged_with?(@fun_tag).should == false
    end

    describe "multiple tagging" do
      before do
        @travel_tag = Tag.gen(:travelling)
        @exp.taggings.create(:tag => @travel_tag)
      end

      it "should return true when asked if tagged with one of the tags it is tagged with" do
        @exp.tagged_with?(@food_tag).should == true
        @exp.tagged_with?(@travel_tag).should == true
      end

      it "should return false when asked if tagged with any of the tags it is not tagged with" do
        @exp.tagged_with?(@fun_tag).should == false
      end
    end

  end # tagging

end