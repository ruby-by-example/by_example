# frozen_string_literal: true

require "tempfile"

module ByExample
  class CodeBlock
    def initialize
      @code = []
      @comment = []
    end

    attr_reader :code, :comment
  end

  class Example
    attr_reader :source_code, :parsed_code, :description, :output

    def initialize(source_code, description)
      @source_code = source_code
      @parsed_code = []
      @description = description
      @output = nil
    end

    def execute
      @output = do_execute
      parse_code
    end

    private

    def add_code_block
      @parsed_code << CodeBlock.new
      @parsed_code.last
    end

    def parse_code
      return if @source_code.empty?

      current_block = add_code_block
      in_comment = false
      @source_code.each_line.with_index do |line, index|
        next if line.chomp.empty?

        if comment_line?(line)
          unless in_comment
            current_block = add_code_block unless index.zero?
            in_comment = true
          end
          current_block.comment << extract_comment(line)
        else
          current_block.code << line.chomp
          in_comment = false
        end
      end
    end
  end

  class RubyExample < Example
    COMMENT_LINE_PATTERN = /\A\s*#\s*(.*)\Z/

    private

    def do_execute
      file = Tempfile.new("ruby-example")
      begin
        file << @source_code
        file.close
        IO.popen("ruby -w #{file.path}", err: %i[child out]) do |io|
          @output = io.read
        end
      ensure
        file.close
        file.unlink
      end
    end

    def comment_line?(line)
      line =~ COMMENT_LINE_PATTERN
    end

    def extract_comment(line)
      COMMENT_LINE_PATTERN.match(line)[1]
    end
  end
end
