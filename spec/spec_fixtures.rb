require "dm-sweatshop"

first_names = %w[James Alicia Harvey Susan Scott Sarah Anne Steve Sofie Nancy]

User.fixture {{
  :name => "James Duncan",
  :login => "login",
  :password => "sickrat",
  :password_confirmation => "sickrat"
}}

# make makes a new Expense object but does not save it
# (uses _new_ internally)
User.fixture(:rand) {{
  :name  => (name = (first_names[rand(first_names.length)] + / \w{2,8}/.gen.capitalize)),
  :login => (login = name.split(' ').first.downcase),
  :password => login,
  :password_confirmation => "sickrat",
  :expenses => rand(12).of { Expense.make }
}}

Group.fixture {{
  :name  => 'A Pepe klan',
  :login => 'pepe_klan',
  :password => 'tio_pepe'
}}

Tag.fixture {{
  :name => /fun|food|travelling|clothes|house/.gen
}}

Tag.fixture(:food) {{
  :name => 'food'
}}

Tag.fixture(:fun) {{
  :name => 'fun'
}}

Tag.fixture(:travelling) {{
  :name => 'travelling'
}}

Tagging.fixture {{
  :expense => Expense.pick,
  :tag => Tag.pick
}}

Expense.fixture {{
  :amount => /(\d{2,5})/.gen,
  :subject => /\w{3,7}/.gen,
  :spent_at => Date.today.send(rand(2).zero? ? :+ : :-, rand(60))
}}
