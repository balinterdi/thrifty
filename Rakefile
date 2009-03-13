require "thrifty"
require "populator"

namespace :db do
  namespace :test do
    desc "does automigration for test database"
    task :automigrate do
      DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://db/test.sqlite3')
      DataMapper.auto_migrate!
    end
  end
  namespace :dev do
    desc "does automigration for development database"
    task :automigrate do
      DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://db/development.sqlite3')
      DataMapper.auto_migrate!
    end
    desc "populates development database with objects"
    task :populate do
      DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://db/development.sqlite3')
      Populator.populate!
    end
    desc "reinit database: automigrate then populate"
    task :reinit => [:automigrate, :populate] do
    end
  end
end

