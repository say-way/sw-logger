# frozen_string_literal: true

module Sw
  module LogFormatter
    class ContextualFormatter < ::Logger::Formatter
      attr_accessor :tags, :context

      def initialize(context: {}, tags: [])
        super()
        self.context = context
        self.tags = tags
      end

      def with_context(context)
        previous_context = self.context
        self.context = context

        yield self
      ensure
        self.context = previous_context
      end

      def with_tags(tags)
        previous_tags = self.tags
        self.tags = tags

        yield self
      ensure
        self.tags = previous_tags
      end

      def current_tags
        tags
      end
    end
  end
end
