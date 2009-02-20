require "rubygems"
# require "sinatra"
require "dm-validations"
require "dm-core"

require "event"
require "expense"
require "group"
require "participant"
require "pot"
require "user"

DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/test.sqlite3')
DataMapper.auto_migrate!