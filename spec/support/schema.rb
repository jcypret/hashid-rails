# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :models, force: true do |t|
    t.string :name
  end

  create_table :models_with_prefix, force: true do |t|
    t.string :name
  end

  create_table :posts, force: true
  create_table :comments, force: true do |t|
    t.belongs_to :post, index: true
  end
end
