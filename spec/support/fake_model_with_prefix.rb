# frozen_string_literal: true

class FakeModelWithPrefix < ActiveRecord::Base
  include Hashid::Rails

  def self.hashid_prefix
    "FMP"
  end

  def self.table_name
    "models_with_prefix"
  end
end
