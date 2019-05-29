# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "byebug"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "hashid/rails"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
require_relative "support/schema"
require_relative "support/fake_model"
require_relative "support/fake_model_with_prefix"
require_relative "support/post"
require_relative "support/comment"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
end
