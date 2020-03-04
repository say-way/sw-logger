# frozen_string_literal: true

require "json"
require "sw/log_formatter/contextual_formatter"

module Sw
  module LogFormatter
    class JsonFormatter < ContextualFormatter
      def initialize(*)
        super
        self.datetime_format ||= "%Y-%m-%dT%H:%M:%S.%6N"
      end

      def call(severity, time, progname, msg)
        payload = context.merge(
          severity: severity,
          timestamp: format_datetime(time),
          progName: progname,
          tags: tags,
          message: msg
        )

        JSON.dump(remove_blank_values(payload)) + "\n"
      end

      private

      def remove_blank_values(payload)
        payload.select do |_, value|
          next if value.nil?

          value = value.strip if value.respond_to?(:strip)
          next if value.respond_to?(:empty?) && value.empty?

          true
        end
      end
    end
  end
end
