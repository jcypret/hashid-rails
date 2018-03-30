# frozen_string_literal: true

module Hashid
  module Rails
    module ParameterPatterns
      def id?(key)
        key.match?(/^id$/)
      end

      def association?(key)
        key.match?(/_id$/)
      end

      def associations?(key)
        key.match?(/_ids$/)
      end

      def nested_association?(key)
        key.match?(/^[0-9]+$/)
      end

      def nested_associations?(key)
        key.match?(/_attributes$/)
      end
    end
  end
end
