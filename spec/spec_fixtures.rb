require "dm-sweatshop"

User.fixture {{
  :name => "James Duncan",
  :login => "login",
  :password => "sickrat",
}}

User.fixture(:rand) {{
  :login => (login = /\w{4,10}/.gen),
  :name  => /\w{2,8} \w{2,8}/.gen,
  :password => (password = /\w{6,10}/.gen),
  :expenses => rand(12).of { Expense.make }
}}

Group.fixture {{
  :name  => 'A Pepe klan',
  :login => 'pepe_klan',
  :password => 'tio_pepe'
}}

Tag.fixture {{
  :name => /\w{3,7}/.gen
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
  :amount => /(\d{2,5})/.gen
}}
