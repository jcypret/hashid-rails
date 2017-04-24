class Comment < ActiveRecord::Base
  include Hashid::Rails

  belongs_to :post
end
