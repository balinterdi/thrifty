require File.dirname(__FILE__) + '/spec_helper'

describe "Sinatra::MyHelpers" do
  before do
    class Sinatra::Application
      include Sinatra::MyHelpers
    end
  end

  describe "param hash handling" do
    describe "with no nested attributes" do
      before do
        # @params = { "status" => "all right" }
        # @new_params = convert_with_nested_attributes(@params)
      end

      it "should not change the params hash" do
        mock_app {
          get '/' do
            @params = { "status" => "all right" }
            @new_params = convert_with_nested_attributes(@params)
          end
        }
        get '/'
        @params["status"].should == @new_params["status"]
      end
    end

    it "makes a hash of value params if they have a []" do
      pending
    end
  end
end