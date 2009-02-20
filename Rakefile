#FIXME: make the require-s dynamic: all the .rb files in the root directory
# should be required

require "dm-validations"
require "dm-core"

require "event"
require "expense"
require "group"
require "participant"
require "pot"
require "user"

namespace :db do
  desc "does automigration for test database"
  namespace :test do
    task :automigrate do
      DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/test.sqlite3')  
      DataMapper.auto_migrate!
    end    
  end
  desc "does automigration for development database"
  namespace :dev do
    task :automigrate do
      DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/development.sqlite3')  
      DataMapper.auto_migrate!
    end
  end
end