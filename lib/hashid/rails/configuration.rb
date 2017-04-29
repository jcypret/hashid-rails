module Hashid
  module Rails
    class Configuration
      attr_accessor :secret, :length, :alphabet, :disable_find

      def initialize
        @secret = ""
        @length = 6
        @alphabet = nil
        @disable_find = false
      end

      def for_table(table_name)
        arguments = ["#{table_name}#{secret}", length]
        arguments << alphabet if alphabet.present?
        arguments
      end
    end
  end
end
