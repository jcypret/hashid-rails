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
    end
  end
end
