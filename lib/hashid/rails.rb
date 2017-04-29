require "hashid/rails/version"
require "hashid/rails/configuration"
require "hashids"
require "active_record"

module Hashid
  module Rails
    # Arbitrary value to verify hashid
    # https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#On_the_Internet_and_in_software
    HASHID_TOKEN = 42

    def self.included(base)
      base.extend ClassMethods
    end

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

    def hashid
      self.class.encode_id(id)
    end
    alias to_param hashid

    module ClassMethods
      def encode_id(ids)
        if ids.is_a?(Array)
          ids.map { |id| hashid_encode(id) }
        else
          hashid_encode(ids)
        end
      end

      def decode_id(ids)
        if ids.is_a?(Array)
          ids.map { |id| hashid_decode(id) }
        else
          hashid_decode(ids)
        end
      end

      def find(hashid)
        if Hashid::Rails.configuration.override_find
          super(decode_id(hashid))
        else
          super(hashid)
        end
      end

      def find_by_hashid(hashid)
        find_by(id: decode_id(hashid))
      end

      def find_by_hashid!(hashid)
        find_by!(id: decode_id(hashid))
      end

      private

      def hashids
        Hashids.new(*Hashid::Rails.configuration.for_table(table_name))
      end

      def hashid_encode(id)
        hashids.encode(HASHID_TOKEN, id)
      end

      def hashid_decode(id)
        decoded_hashid = hashids.decode(id.to_s)
        return id unless valid_hashid?(decoded_hashid)
        decoded_hashid.last
      end

      def valid_hashid?(decoded_hashid)
        decoded_hashid.size == 2 && decoded_hashid.first == HASHID_TOKEN
      end
    end
  end
end
