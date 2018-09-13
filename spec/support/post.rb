# frozen_string_literal: true

class Post < ActiveRecord::Base
  include Hashid::Rails

  has_many :comments
end

class OtherPost < ActiveRecord::Base
  self.table_name = "posts"
  has_many :comments, foreign_key: "post_id"
end
