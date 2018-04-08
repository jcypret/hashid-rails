# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "byebug"

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "hashid/rails"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
require_relative "support/schema"
require_relative "support/fake_model"
require_relative "support/author"
require_relative "support/post"
require_relative "support/image"
require_relative "support/comment"
require_relative "support/topic"
