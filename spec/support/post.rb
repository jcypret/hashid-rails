# frozen_string_literal: true

class Post < ActiveRecord::Base
  include Hashid::Rails

  has_one :image
  belongs_to :author
  has_many :comments
  has_and_belongs_to_many :topics
end
