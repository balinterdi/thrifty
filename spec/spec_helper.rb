require 'sinatra'
require 'sinatra/test/rspec'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'the_pot'))
require File.expand_path(File.dirname(__FILE__) + "/spec_fixtures")

Sinatra::Application.set(
  :environment => :test,
  :run => false,
  :raise_errors => true,
  :logging => false
)

DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/test.sqlite3')

# copied from the helper.rb in sinatra's test library
module Sinatra::Test
  # Sets up a Sinatra::Base subclass defined with the block
  # given. Used in setup or individual spec methods to establish
  # the application.
  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end
end

class Sinatra::Base
  # Allow assertions in request context
  include Test::Unit::Assertions
end