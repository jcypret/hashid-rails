require "simplecov"
SimpleCov.start

require "byebug"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "hashid/rails"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
require_relative "support/schema"
require_relative "support/fake_model"
