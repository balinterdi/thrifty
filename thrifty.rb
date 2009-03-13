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
require "tag"
require "tagging"
require "user"

require "my_helpers"

configure :development do
  set :mode, 'development'
  enable :sessions
  DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/development.sqlite3')
end

configure :production do
  set :mode, 'production'
  enable :sessions
  DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/production.sqlite3')
end

# mime :json, "application/json"

helpers do

  include Sinatra::MyHelpers

  # NOTE: using this for implementing an after-render callback
  # It will break if the render method's signature changes
  # I wanted to use this to reset the flash but render can be called
  # multiple times for rendering a page so flash elements would only
  # be available after the first render...
  old_render = instance_method(:render)
  define_method(:render) do |engine, template, options|
    # puts "XXX Rendering with engine: #{engine} template: #{template} options: #{options.inspect}"
    old_render.bind(self).call(engine, template, options)
  end

  def do_auth
    user = User.authenticate(params[:login], params[:password])
    self.current_user = user
    return user
  end

  def current_user=(user)
    session["user"] = user.id
  end

  def current_user
    User.get(session["user"])
  end

end

before do
  @flash = reset_flash
end

get '/main.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :main
end

get '/register' do
  haml :register
end

post '/register' do
  if params[:user][:password] != params[:user][:re_password]
    flash[:error] = "The passwords do not match."
    haml :register
  else
    # NOTE: params[:user].delete(:re_password) will not work!
    # probably that's because :re_password is not found as key
    # when looking for the value to delete so it does not do anything.
    params[:user].delete("re_password")
    user = User.create(params[:user])
    if user
      current_user = user
      flash[:ok] = "The new user has been created."
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
    flash[:ok] = "Welcome #{current_user.name}."
    redirect '/expenses'
  else
    flash[:error] = "Incorrect user name or password. Try again."
    haml :login
  end
end

get '/logout' do
  session.delete("user")
  flash[:ok] = "You have logged out."
  haml :login
end

get '/' do
  haml :dashboard
end

get '/events' do
  # TODO: only list Events
  # the user is part of
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

get '/expenses/new' do
  @expenses = current_user.expenses
  @tags = @expenses.map { |exp| exp.tags }.flatten.uniq
  haml :new_expense
end

get '/expenses' do
  @expenses = current_user.expenses
  @tags = @expenses.map { |exp| exp.tags }.flatten.uniq
  haml :expenses
end

get '/get_expenses' do
  # content_type :json
  tag_ids = (params["tags"] || []).map { |t| t.to_i }
  expenses = current_user.get_expenses_with_tags(tag_ids)
  unless params["dates"].nil?
    from_date, to_date = params["dates"].map do |date|
      date.empty? ? nil : Date.parse(date)
    end
    expenses_between_dates = current_user.get_expenses_between_dates(from_date, to_date)
    expenses = expenses.select { |exp| expenses_between_dates.include?(exp) }
  end
  total_amount = expenses.inject(0) { |sum, exp| sum + exp.amount }
  total_amount.to_s + ":" + ( partial :expense, :collection => expenses )
end

post '/expenses' do
  if params[:expense]["spent_at"].strip.empty?
    params[:expense]["spent_at"] = nil
  else
    params[:expense]["spent_at"] = Date.parse(params[:expense]["spent_at"].strip)
  end
  tags = (params[:expense].delete("tags")).split.map do |tag|
    Tag.first_or_create(:name => tag)
  end
  expense = Expense.new(params[:expense].merge(:user => current_user))
  tags.each { |tag| expense.taggings.build(:tag_id => tag.id) }
  if expense.save
    flash[:ok] = "New expense created."
    redirect "/expenses/new"
  else
    flash[:error] = "Error during expense creation."
    haml :new_expense
  end
end

get %r{/expenses/(.+)/edit} do
  id = params[:captures].first
  @expense = Expense.get(id)
  haml :edit_expense
end

put %r{/expenses/(.*)/update} do
  id = params[:captures].first
  expense = Expense.get(id)
  if expense.update_attributes(params[:expense])
    flash[:ok] = "Expense updated."
    redirect '/expenses/new'
  else
    flash[:error] = "Error updating expense"
    redirect "/expenses/#{expense.id}/edit"
  end
end

delete %r{/expenses/(.*)} do
  id = params[:captures].first
  exp = Expense.get(id)
  amount = exp.amount
  exp.destroy
  # The return value of this method
  # will be returned to a caller
  "#{id}:#{amount}"
end