require File.dirname(__FILE__) + '/spec_helper'

describe "Expense" do
  describe "summing per tag" do
    before do
      @user = User.gen
      expenses = (1..10).map { |a| Expense.gen(:amount => a) }
      @user.expenses = expenses; @user.save
      tags = [ Tag.gen(:food), Tag.gen(:fun) ]
      expenses.each_with_index { |exp, i| exp.taggings.create(:tag => tags[i % 2]) }
    end
    it "should only contain expenses with the given tag" do
      @user.sum_expenses_for_tag("food").should == 1 + 3 + 5 + 7 + 9
      @user.sum_expenses_for_tag("fun").should == 2 + 4 + 6 + 8 + 10
    end
  end
end