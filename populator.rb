require File.expand_path(File.join(File.dirname(__FILE__), 'spec', 'spec_fixtures'))

class Populator
  def self.populate!
    # have unique-named tags
    10.times do
      tag = Tag.gen
      Tag.get(tag.id).destroy if Tag.all(:name => tag.name).length > 1
    end
    # generating users fixtures will also generate expenses
    users = 5.of { User.gen(:rand) }
    taggings = 30.of { Tagging.gen }
  end
end