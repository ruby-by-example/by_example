# frozen_string_literal: true

require_relative "example.rb"

module ByExample
  class Topic
    def initialize(name)
      @name = name
      @structure = []
    end

    def example(source_code, comment: nil)
      @structure << Example.new(source_code, comment)
    end
  end
end
