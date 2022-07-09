# frozen_string_literal: true

module Hashid
  module Rails
    class Configuration
      attr_accessor :salt,
                    :pepper,
                    :min_hash_length,
                    :alphabet,
                    :override_find,
                    :override_to_param,
                    :sign_hashids

      def initialize
        @salt = ""
        @pepper = ->(klass) { klass.table_name }
        @min_hash_length = 6
        @alphabet = "abcdefghijklmnopqrstuvwxyz" \
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                    "1234567890"
        @override_find = true
        @override_to_param = true
        @sign_hashids = true
      end

      def to_args
        ["#{pepper}#{salt}", min_hash_length, alphabet]
      end
    end
  end
end
