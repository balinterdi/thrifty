require File.dirname(__FILE__) + '/spec_helper'

describe "Sinatra::MyHelpers" do

  describe "messaging through flash" do
    before do
      mock_app {
        include Sinatra::MyHelpers
        get '/login' do
          session[:ok] = "Ok."
        end
        get '/' do
          @ok = session[:ok]
        end
      }
    end
    
    it "should retain flash messages b/w two consecutive messages" do
      get '/login'
      get '/'
      @ok.should == "Ok."
    end
    
  end
  
  describe "sessions" do
    before do
      mock_app {
        get '/' do
          @ok = session[:ok]
          session[:ok]
        end
      }
    end
    
    it "should retain things stored in session b/w actions" do
      get '/', :env => { 'rack.session' => { :ok => 'Ok.' } }
      body.should == 'Ok.'
      @ok.should == "Ok."
    end
    
  end
  

end