class FakeModel < ActiveRecord::Base
  include Hashid::Rails

  def self.table_name
    "models"
  end
end
