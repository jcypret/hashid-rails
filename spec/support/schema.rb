ActiveRecord::Schema.define do
  self.verbose = false

  create_table :models, :force => true do |t|
    t.timestamps
  end
end
