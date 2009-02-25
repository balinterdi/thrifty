require File.dirname(__FILE__) + '/spec_helper'

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
  end

end