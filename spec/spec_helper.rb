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