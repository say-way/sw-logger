# frozen_string_literal: true

require "sw/log_formatter/contextual_formatter"

module Sw
  module LogFormatter
    class SimpleFormatter < ContextualFormatter
      def call(_severity, _time, _progname, msg)
        tag_string = tags.map { |tag| "[#{tag}] " }.join
        context_string = context.map { |k, v| "[#{k}=#{v}] " }.join

        tag_string + context_string + msg2str(msg) + "\n"
      end
    end
  end
end
