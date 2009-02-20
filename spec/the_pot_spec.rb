require File.dirname(__FILE__) + '/spec_helper'

describe "The Pot" do
  it "should respond to the root request" do
    get '/'
    @response.should be_ok
  end
end