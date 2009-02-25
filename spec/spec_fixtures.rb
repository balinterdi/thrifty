require "dm-sweatshop"

User.fixture {{
  :name => "James Duncan",
  :login => "login",
  :password => "sickrat",
}}

Group.fixture {{
  :name  => 'A Pepe klan',
  :login => 'pepe_klan',
  :password => 'tio_pepe'
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

Expense.fixture {{
  :amount => /(\d{2,5})/.gen
}}