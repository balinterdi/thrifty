require File.expand_path(File.join(File.dirname(__FILE__), 'spec', 'spec_fixtures'))

class Populator
  def self.populate!
    tags  = 10.of { Tag.gen }
    # generating users fixtures will also generate expenses
    users = 5.of { User.gen(:rand) }
    taggings = 30.of { Tagging.gen }
  end
end