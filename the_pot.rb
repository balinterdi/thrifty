require "rubygems"
require "ruby-debug"
require "sinatra"
# NOTE: do not swap the order of dm-validations and dm-core
# or Gem. Dependency Hell can ensue!
require "dm-validations"
require "dm-core"

require "event"
require "expense"
require "group"
require "participant"
require "pot"
require "user"

configure :development do
  set :mode, 'development'
  enable :sessions
  DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/development.sqlite3')  
end

helpers do
  def do_auth
    group = Group.authenticate(params[:login], params[:password])
    self.current_group = group
    return group
  end
  def current_group=(group)
    session["group"] = group.id
  end
  def current_group
    Group.get(session["group"])
  end
end

get '/main.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :main
end

get '/login' do
  haml :login
end

post '/login' do
  auth = do_auth
  redirect '/secret' if auth
  puts "invalid credentials."
  haml :login
end

get '/' do
  "I'm The Pot"
end

get '/secret' do
  haml :new_expense
end