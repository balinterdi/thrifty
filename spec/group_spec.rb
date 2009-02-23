require File.dirname(__FILE__) + '/spec_helper'

describe "Group" do
  before do
    Group.all.destroy!
    @group = Group.generate
  end

  it "should not be able to auth. with bad login" do
    Group.authenticate(@group.login, @group.password + "x").should == nil
  end
  it "should not be able to auth. with bad password" do
    Group.authenticate(@group.login, @group.password + "x").should == nil
  end

  it "should be able to authenticate with the correct credentials" do
    Group.authenticate(@group.login, @group.password).should == @group
  end

  it "should retain the logged in group" do
  end

end