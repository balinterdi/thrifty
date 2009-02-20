require File.dirname(__FILE__) + '/spec_helper'

describe "Group" do
  before do
    @group = Group.generate
  end
  
  it "should be self-evident" do
    1.should == 1
  end
end