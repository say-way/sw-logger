# frozen_string_literal: true

require "logger"
require "sw/logger/version"
require "sw/log_formatter/simple_formatter"
require "sw/log_formatter/json_formatter"
require "sw/log_formatter/default_formatter"

module Sw
  def self.logger(*args)
    Sw::Logger.new(*args)
  end

  def self.json_logger(*args)
    Sw::Logger.new(*args).tap do |logger|
      logger.formatter = Sw::LogFormatter::JsonFormatter.new
    end
  end

  def self.simple_logger(*args)
    Sw::Logger.new(*args).tap do |logger|
      logger.formatter = Sw::LogFormatter::SimpleFormatter.new
    end
  end

  class Logger < ::Logger
    def initialize(*)
      super
      self.formatter ||= Sw::LogFormatter::DefaultFormatter.new
    end

    def with_context(context = {})
      return dup.tap { |it| it.formatter.context = context } unless block_given?

      formatter.with_context(context.to_h) { yield self }
    end

    def tagged(*tags)
      tags = Array(tags).flatten
      return dup.tap { |it| it.formatter.tags = tags } unless block_given?

      formatter.with_tags(tags) { yield self }
    end

    private

    def initialize_copy(original)
      self.formatter = original.formatter.dup
    end
  end
end
