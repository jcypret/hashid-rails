require 'hashid/rails/version'
require 'hashids'
require 'active_record'

module Hashid
  module Rails

    # Get configuration or load defaults
    def self.configuration
      @configuration ||= Configuration.new
    end

    # Set configuration settings with a block
    def self.configure
      yield(configuration)
    end

    # Reset gem configuration to defaults
    def self.reset
      @configuration = Configuration.new
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def encoded_id
      self.class.encode_id(id)
    end

    def to_param
      encoded_id
    end
    alias_method :hashid, :to_param

    module ClassMethods

      def hashids
        secret = Hashid::Rails.configuration.secret
        length = Hashid::Rails.configuration.length
        alphabet = Hashid::Rails.configuration.alphabet

        arguments = ["#{table_name}#{secret}", length]
        arguments << alphabet if alphabet.present?

        Hashids.new(*arguments)
      end

      def encode_id(id)
        hashid_encode(id)
      end

      def decode_id(ids)
        if ids.is_a?(Array)
          ids.map { |id| hashid_decode(id) }
        else
          hashid_decode(ids)
        end
      end

      def find(hashid)
        model_reload? ? super(hashid) : super( decode_id(hashid) || hashid )
      end

      private

      def model_reload?
        caller.any? {|s| s =~ /active_record\/persistence.*reload/}
      end

      def hashid_decode(id)
        hashids.decode(id.to_s).first
      end

      def hashid_encode(id)
        hashids.encode(id)
      end
    end

    class Configuration
      attr_accessor :secret, :length, :alphabet

      def initialize
        @secret = ''
        @length = 6
        @alphabet = nil
      end
    end

  end
end

ActiveRecord::Base.send :include, Hashid::Rails
