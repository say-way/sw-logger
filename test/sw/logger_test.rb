require "test_helper"
require "time"

module Sw
  class LoggerTest < Minitest::Test
    def setup
      @io = StringIO.new
      @logger = Sw.logger(@io)
    end

    def test_default_logger_writes_info_message
      @logger.info("Hello World!")
      assert_includes @io.string, "INFO -- : Hello World!"
    end

    def test_default_logger_writes_tagged_info_message
      @logger.tagged("FoO").info("Hello World!")
      assert_includes @io.string, "INFO -- : [FoO] Hello World!"
      @logger.tagged("Bar", "Baz") { |l| l.info("Bye World!") }
      assert_includes @io.string, "INFO -- : [Bar] [Baz] Bye World!"
    end

    def test_default_logger_writes_context_enriched_info_message
      @logger.with_context(source: :app).info("Hello World!")
      assert_includes @io.string, "INFO -- : [source=app] Hello World!"
      @logger.with_context(locals: { foo: 42 }) { |l| l.info("Bye World!") }
      assert_includes @io.string, "INFO -- : [locals={:foo=>42}] Bye World!"
    end

    def test_default_logger_writes_tagged_context_enriched_info_message
      @logger.tagged("foo").with_context(source: :app).info("Hello World!")
      assert_includes @io.string, "INFO -- : [foo] [source=app] Hello World!"
      @logger.with_context(source: :app).tagged("foo") do |logger|
        logger.info("Bye World!")
      end
      assert_includes @io.string, "INFO -- : [foo] [source=app] Bye World!"
    end

    def test_json_logger_writes_info_message
      Sw.json_logger(@io).info("Hello World!")
      entry = JSON.parse(@io.string, symbolize_names: true)
      assert_equal "INFO", entry[:severity]
      assert Time.iso8601(entry[:timestamp]).is_a?(Time)
      assert_equal "Hello World!", entry[:message]
    end

    def test_json_logger_writes_tagged_context_enriched_info_message
      logger = Sw.json_logger(@io)
      logger.tagged("foo").with_context(source: :app).info("Hello World!")
      entry = JSON.parse(@io.string, symbolize_names: true)
      assert_equal ["foo"], entry[:tags]
      assert_equal "app", entry[:source]
      assert_equal "Hello World!", entry[:message]
    end
  end
end
