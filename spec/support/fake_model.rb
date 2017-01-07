class FakeModel < ActiveRecord::Base
  def self.table_name
    "models"
  end
end
