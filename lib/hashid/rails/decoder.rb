# frozen_string_literal: true

require "hashid/rails/parameter_patterns"

module Hashid
  module Rails
    class Decoder
      class << self
        include ParameterPatterns

        def decode_params(parent_class, params)
          _decode_params(parent_class, params)
        end

        private

        def _decode_params(parent_class, params, child_name = nil)
          dup = HashWithIndifferentAccess.new(params.dup)
          dup.update(dup) do |k, v|
            if requires_decoding?(k)
              decode(parent_class, k, v, child_name)
            else
              v
            end
          end
        end

        def requires_decoding?(key)
          id?(key) ||
            association?(key) ||
            associations?(key) ||
            nested_association?(key) ||
            nested_associations?(key)
        end

        # rubocop:disable Metrics/MethodLength
        def decode(parent_class, key, value, child_name)
          if id?(key)
            decode_id(parent_class, value)
          elsif association?(key)
            decode_association(parent_class, key, value)
          elsif associations?(key)
            decode_associations(parent_class, key, value)
          elsif nested_association?(key)
            decode_nested_association(parent_class, value, child_name)
          elsif nested_associations?(key)
            decode_nested_associations(parent_class, key, value)
          end
        end
        # rubocop:enable Metrics/MethodLength

        def decode_id(parent_class, hashid)
          parent_class.decode_id(hashid, fallback: true)
        rescue NoMethodError
          hashid
        end

        def decode_child_id(parent_class, hashid, child_name)
          association = parent_class.reflect_on_association(child_name)
          return hashid if association.nil?
          decode_id(association.klass, hashid)
        end

        def decode_child_ids(parent_class, hashids, child_name)
          hashids.map do |hashid|
            decode_child_id(parent_class, hashid, child_name)
          end
        end

        def decode_association(parent_class, key, value)
          child_name = key.to_s.gsub("_id", "")
          decode_child_id(parent_class, value, child_name)
        end

        def decode_associations(parent_class, key, value)
          child_name = key.to_s.gsub("_ids", "s")
          decode_child_ids(parent_class, value, child_name)
        end

        def decode_nested_association(parent_class, value, child_name)
          association = parent_class.reflect_on_association(child_name)
          child_class = association.klass
          _decode_params(child_class, value)
        end

        def decode_nested_associations(parent_class, key, value)
          child_name = key.to_s.gsub("_attributes", "")
          _decode_params(parent_class, value, child_name)
        end
      end
    end
  end
end
