# frozen_string_literal: true

class Topic < ActiveRecord::Base
  include Hashid::Rails

  has_and_belongs_to_many :posts, join_table: :posts_topics
end
