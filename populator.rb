require File.expand_path(File.join(File.dirname(__FILE__), 'spec', 'spec_fixtures'))

class Populator
  def self.populate!
    user = User.gen
    user.save
  end
end