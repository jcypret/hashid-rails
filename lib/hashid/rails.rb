require 'hashid/rails/version'
require 'hashids'
require 'active_record'

module Hashid
  module Rails

    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
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
        secret = Hashid::Rails.configuration ? Hashid::Rails.configuration.secret : ''
        Hashids.new("#{table_name}#{secret}", 6)
      end

      def encode_id(id)
        hashids.encode(id)
      end

      def decode_id(id)
        hashids.decode(id.to_s).first
      end

      def find(hashid)
        return super hashid if caller.select{|s| s =~ /reload/ && s =~ /active_record\/persistence/}.any?
        super decode_id(hashid) || hashid
      end
    end

    class Configuration
      attr_accessor :secret

      def initialize
        @secret = ''
      end

    end
  end

end

ActiveRecord::Base.send :include, Hashid::Rails
