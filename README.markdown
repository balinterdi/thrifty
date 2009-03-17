# Thrifty

## About

Thrifty is a simple "two-page" application written in [Sinatra][1] to keep track of your spending. After a quick registration you can start adding your expenses. You can add tags for each expense and optionally set a date the money was spent.

On the other page of the app you can filter your expenses by selecting the tags you provided when creating the expenses. You can also narrow down your results by providing a date range.

***

## Running it

### On your machine

You will need to install the following gems to run Thrifty on your machine:

    gem install sinatra
    gem install datamapper
    gem install sqlite3-ruby
    gem install do_sqlite3

Before the first run you'll need to create the sqlite database and the tables the app uses. I provided a rake task to do this, so you simply need to do:

    rake db:dev:automigrate

If you'd like your database to be populated with some semi-random data so you don't need to create user and spending instances manually, you can do:

    rake db:dev:populate

If you'd like to recreate the database tables and populate them, you can run:

    rake db:dev:reinit

Once all the things are in place, you can launch the app simply be typing:

    ruby thrifty.rb

### On the test server

If you would like a test ride without bothering with installing gems, head over to [thrify.heroku.com](http://thrifty.heroku.com). Please let me know if it is not available there. Please note that I can not assume any responsibility for the safety, integrity or secrecy of your data stored on this test server.

***

## Further development

This is a very early beta so there are definitely some outstanding issues that I would like to address. Perhaps the major one is adding validations. Also, I am planning to add UTF-8 support so non-English speakers can add/tag their spending in their mother tongue.

***

## Release notes

The code is released under the MIT license so please feel free and even encouraged to fork away! Also, if you have suggestions or comments, just let me know.

  [1]: http://www.sinatrarb.com/

Copyright (c) 2009 Balint Erdi, released under the MIT license