# frozen_string_literal: true

require "sw/log_formatter/contextual_formatter"

module Sw
  module LogFormatter
    class DefaultFormatter < ContextualFormatter
      def call(severity, time, progname, msg)
        tag_string = tags.map { |tag| "[#{tag}] " }.join
        context_string = context.map { |k, v| "[#{k}=#{v}] " }.join
        message = tag_string + context_string + msg2str(msg)
        super(severity, time, progname, message)
      end
    end
  end
end
