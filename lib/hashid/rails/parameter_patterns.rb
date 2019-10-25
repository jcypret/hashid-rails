# frozen_string_literal: true

module Hashid
  module Rails
    module ParameterPatterns
      def id?(key)
        (/^id$/ =~ key).present?
      end

      def association?(key)
        (/_id$/ =~ key).present?
      end

      def associations?(key)
        (/_ids$/ =~ key).present?
      end

      def nested_association?(key)
        (/^[0-9]+$/ =~ key).present?
      end

      def nested_associations?(key)
        (/_attributes$/ =~ key).present?
      end
    end
  end
end
