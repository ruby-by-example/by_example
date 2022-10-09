# frozen_string_literal: true

require_relative "by_example/version"
require_relative "by_example/dsl.rb"

module ByExample
  class Error < StandardError; end

  def self.topic(name, &block)
    Topic.new(name).instance_eval(&block)
  end
end
