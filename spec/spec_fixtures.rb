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