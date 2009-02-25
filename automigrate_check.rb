require "rubygems"
require "dm-validations"
require "dm-core"

require "the_pot"

DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/test.sqlite3')
DataMapper.auto_migrate!