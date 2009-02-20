require "dm-core"

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