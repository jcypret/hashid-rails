require 'hashid/rails/version'
require 'hashids'
require 'active_record'

module Hashid
  module Rails
    def hashid(options = {})
      extend ClassMethods
      include InstanceMethods

      cattr_accessor :hashid_options
      self.hashid_options = ({length: 6}.merge(options))
    end

    module InstanceMethods
      def encoded_id
        self.class.encode_id(id)
      end

      def to_param
        encoded_id
      end
      alias_method :hashid, :to_param
    end

    module ClassMethods
      def hashids
        salt = if self.hashid_options[:secure]
                 "#{table_name}:#{::Rails.application.secrets.secret_key_base}"
               else
                 table_name
               end
        hash_length = self.hashid_options[:length]
        Hashids.new(salt, hash_length)
      end

      def encode_id(id)
        hashids.encode(id)
      end

      def decode_id(id)
        hashids.decode(id.to_s).first
      end

      def find(hashid)
        super decode_id(hashid) || hashid
      end
    end
  end
end

ActiveRecord::Base.extend Hashid::Rails
