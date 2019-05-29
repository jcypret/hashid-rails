# frozen_string_literal: true

module Hashid
  module Rails
    class Configuration
      attr_accessor :alphabet,
                    :hashid_prefix_separator,
                    :min_hash_length,
                    :override_find,
                    :salt,
                    :sign_hashids,
                    :use_prefix

      def initialize
        @salt = ""
        @min_hash_length = 6
        @alphabet = "abcdefghijklmnopqrstuvwxyz" \
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                    "1234567890"
        @override_find = true
        @sign_hashids = true
        @use_prefix = true
        @hashid_prefix_separator = "!"
      end

      def for_table(table_name)
        ["#{table_name}#{salt}", min_hash_length, alphabet]
      end
    end
  end
end
