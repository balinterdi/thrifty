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

  it "should correctly store the encrypted password" do
    # puts "encrypted password: #{@user.encrypt(@user.password)}"
    @user.encrypt(@user.password) == @user.encrypted_password
  end

  it "should not be able to auth. with bad login" do
    User.authenticate(@user.login + "x", @user.password).should == nil
  end
  it "should not be able to auth. with bad password" do
    User.authenticate(@user.login, @user.password + "x").should == nil
  end

  it "should be able to authenticate with the correct credentials" do
    User.authenticate(@user.login, @user.password).should == @user
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
        User.all.destroy!
        Expense.all.destroy!
        Tag.all.destroy!
        food_tag = Tag.gen(:food)
        travel_tag = Tag.gen(:travelling)
        @exp1 = Expense.gen
        @exp2 = Expense.gen
        @exp3 = Expense.gen
        @exp1.taggings.create(:tag => food_tag)
        @exp1.taggings.create(:tag => travel_tag)
        @exp2.taggings.create(:tag => travel_tag)

        user = User.gen
        user.expenses = [@exp1, @exp2, @exp3]
        @exps = user.get_expenses_with_tags([food_tag, travel_tag])
      end

      it "should contain the expenses that are tagged with any of the passed tags" do
        @exps.should include(@exp1)
        @exps.should include(@exp2)
      end

      it "should not contain the expenses that are not tagged with any of the passed tags" do
        @exps.should_not include(@exp3)
      end

      it "should not contain an expense that has multiple matching tags" do
        @exps.length.should == 2
      end

    end # with multiple tagged

  end # tagging expenses

  describe "finding expenses by dates" do
    before do
      @exp_1 = Expense.gen(:spent_at => Date.today - 7)
      @exp_2 = Expense.gen(:spent_at => Date.today - 4)
      @user.expenses = [@exp_1, @exp_2]
    end

    it "should return all the expenses if no dates are given" do
      @user.get_expenses_between_dates.should include(@exp_1)
      @user.get_expenses_between_dates.should include(@exp_2)
    end

    it "should return the expenses spent later than a from date" do
      @user.get_expenses_between_dates(Date.today - 5).should include(@exp_2)
      @user.get_expenses_between_dates(Date.today - 5).should_not include(@exp_1)
    end

    it "should return the expenses spent sooner than a to date" do
      @user.get_expenses_between_dates(nil, Date.today - 5).should include(@exp_1)
      @user.get_expenses_between_dates(nil, Date.today - 5).should_not include(@exp_2)
    end

    it "should return the expenses spent later than a from date and sooner than a to date" do
      expenses = @user.get_expenses_between_dates(Date.today - 8, Date.today - 2)
      expenses.should include(@exp_1)
      expenses.should include(@exp_2)
    end

  end

end