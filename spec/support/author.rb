# frozen_string_literal: true

class Author < ActiveRecord::Base
  include Hashid::Rails

  has_many :posts
end
