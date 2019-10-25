# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :models, force: true do |t|
    t.string :name
  end

  create_table :authors, force: true
  create_table :posts, force: true do |t|
    t.belongs_to :author, index: true
    t.string :title
    t.integer :sponsor_id
  end
  create_table :images, force: true do |t|
    t.belongs_to :post, index: true
  end
  create_table :comments, force: true do |t|
    t.belongs_to :post, index: true
  end
  create_table :topics, force: true
  create_table :posts_topics, id: false, force: true do |t|
    t.integer :post_id
    t.integer :topic_id
  end
end
