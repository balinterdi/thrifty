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

require "my_helpers"

configure :development do
  set :mode, 'development'
  enable :sessions
  DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/development.sqlite3')
end

helpers do

  include Sinatra::MyHelpers

  old_render = instance_method(:render)
  define_method(:render) do |engine, template, options|
    # puts "XXX Hello"
    old_render.bind(self).call(engine, template, options)
  end

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

before do
  # reset_flash
end

get '/main.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :main
end

get '/register' do
  haml :register
end

post '/register' do
  if params[:group][:password] != params[:group][:re_password]
    flash[:error] = "The passwords do not match."
    haml :register
  else
    # NOTE: params[:group].delete(:re_password) will not work!
    # probably that's because :re_password is not found as key
    # when looking for the value to delete so it does not do anything.
    params[:group].delete("re_password")
    group = Group.create(params[:group])
    if group
      current_group = group
      flash[:ok] = "The new group has been created."
      redirect '/'
    else
      flash[:error] = "Bad data. Registration failed. Try again."
      haml :register
    end
  end
end

get '/login' do
  haml :login
end

post '/login' do
  auth = do_auth
  if auth
    flash[:ok] = "You are logged in."
    redirect '/events'
  else
    flash[:error] = "Incorrect user name or password. Try again."
    haml :login
  end
end

get '/logout' do
  session.delete("group")
  flash[:ok] = "You have logged out."
  haml :login
end

get '/' do
  haml :dashboard
end

get '/events' do
  # TODO: only list Events
  # the group is part of
  @events = Event.all
  haml :events
end

get '/events/new' do
  haml :new_event
end

post '/events' do
  event = Event.create(params[:event])
  flash[:ok] = "The new event has been created."
  redirect "/events/#{event.id}"
end

get %r{/events/([\d]+)} do
  # we suppose a numeric id.
  id = params[:captures].first
  @event = Event.get(id)

  haml :show_event
end

post %r{/events/([\d]+)/expenses} do
  id = params[:captures].first
  @event = Event.get(id)
  @event.expenses.create(params[:expense])
  redirect "/events/#{id}"
end