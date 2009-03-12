require File.dirname(__FILE__) + '/spec_helper'

describe "Expense" do
  before do
    Expense.all.destroy!
    @expense = Expense.gen
  end

  it "should be set to the current date for spent_at if not given" do
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

  describe "spent at dates" do
    before do
      @expense.spent_at = Date.today - 3
    end

    describe "after" do
      it "should return true if no date is passed" do
        @expense.should be_spent_after(nil)
      end

      it "should return true if spent on the same date as the passed one" do
        @expense.should be_spent_after(Date.today - 3)
      end

      it "should return true if spent sooner than the passed date" do
        @expense.should be_spent_after(Date.today - 4)
      end

      it "should return false if spent later than the passed date" do
        @expense.should_not be_spent_after(Date.today - 2)
      end

    end

    describe "before" do
      it "should return true if no date is passed" do
        @expense.should be_spent_before(nil)
      end

      it "should return true if spent on the same date as the passed one" do
        @expense.should be_spent_before(Date.today - 3)
      end

      it "should return true if spent sooner than the passed date" do
        @expense.should be_spent_before(Date.today - 2)
      end

      it "should return false if spent later than the passed date" do
        @expense.should_not be_spent_before(Date.today - 4)
      end

    end

  end # spent at dates

end