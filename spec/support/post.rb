# frozen_string_literal: true

class Post < ActiveRecord::Base
  include Hashid::Rails

  has_many :comments
end
