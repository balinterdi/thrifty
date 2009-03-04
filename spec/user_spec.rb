require File.dirname(__FILE__) + '/spec_helper'
require "ruby-debug"

def exp_with_amount(amount)
  Expense.first(:amount => amount)
end

def tag_with_name(name)
  Tag.first(:name => name)
end

describe "User" do
  before do
    User.all.destroy!
    @user = User.generate
  end

  it "should not be able to auth. with bad login" do
    User.authenticate(@user.login, @user.password + "x").should == nil
  end
  it "should not be able to auth. with bad password" do
    User.authenticate(@user.login, @user.password + "x").should == nil
  end

  it "should be able to authenticate with the correct credentials" do
    User.authenticate(@user.login, @user.password).should == @user
  end

  it "should retain the logged in group" do
    pending
  end

  describe "tagging expenses" do
    before do
      Expense.all.destroy!
      Tag.all.destroy!
      expenses = (1..10).map { |a| Expense.gen(:amount => a) }
      @user.expenses = expenses; @user.save
      tags = [ Tag.gen(:food), Tag.gen(:fun) ]
      expenses.each_with_index { |exp, i| exp.taggings.create(:tag => tags[i % 2]) }
    end

    it "should correctly sum up expenses with one given tag" do
      @user.sum_expenses_for_tag("food").should == 1 + 3 + 5 + 7 + 9
      @user.sum_expenses_for_tag("fun").should == 2 + 4 + 6 + 8 + 10
    end

    it "should return an empty list if no tags are given" do
      @user.get_expenses_with_tags([]).should == []
    end

    it "should contain the expenses tagged with one given tag" do
      exps = @user.get_expenses_with_tags([tag_with_name("food")])
      exps.should include(exp_with_amount(1))
      exps.should include(exp_with_amount(9))
    end

    it "should not contain the expenses not tagged with that one given tag" do
      exps = @user.get_expenses_with_tags([tag_with_name("food")])
      exps.should_not include(exp_with_amount(2))
      exps.should_not include(exp_with_amount(6))
    end

    describe "with multiple taggings" do
      before do
        Tagging.all.destroy!
        travel_tag = Tag.gen(:travelling)
        exp = @user.expenses.first(:amount => 4)
        exp.taggings << Tagging.create(:tag => travel_tag, :expense => exp)
        @user.save
        # exp_with_amount(4).taggings.create(:tag => travel_tag)
        @exps = @user.get_expenses_with_tags([tag_with_name("food"), travel_tag])
      end

      it "should contain the expenses that are tagged with any of the passed tags" do
        @exps.should include(exp_with_amount(1))
        @exps.should include(exp_with_amount(4))
      end

      it "should not contain the expenses that are not tagged with any of the passed tags" do
        # @exps = @user.get_expenses_with_tags([tag_with_name("food"), tag_with_name("travelling")])
        @exps.should_not include(exp_with_amount(6))
      end

    end # with multiple tagged


  end

end