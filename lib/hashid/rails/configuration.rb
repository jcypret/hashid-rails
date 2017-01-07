module Hashid
  module Rails
    class Configuration
      attr_accessor :secret, :length, :alphabet

      def initialize
        @secret = ""
        @length = 6
        @alphabet = nil
      end
    end
  end
end
