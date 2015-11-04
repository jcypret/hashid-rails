require 'hashid/rails/version'
require 'hashids'
require 'active_record'

module Hashid
  module Rails
    def hashid
      extend ClassMethods
      include InstanceMethods
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
        Hashids.new(table_name, 6)
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
