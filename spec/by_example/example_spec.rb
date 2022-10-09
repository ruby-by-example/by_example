# frozen_string_literal: true

RSpec.describe ByExample::RubyExample do
  context "When a valid ruby source code is provided" do
    subject(:example) do
      instance = described_class.new(<<~RUBY, "A description")
        puts "Hello, World!"

        # This comment will initiate
        # a new block
        puts "Goodbye"
      RUBY
      instance.execute
      instance
    end

    it "contains the source code" do
      expect(example.source_code).not_to be_empty
    end

    it "contains a description of the example" do
      expect(example.description).to eq "A description"
    end

    it "contains the output of the example program" do
      expect(example.output).to eq "Hello, World!\nGoodbye\n"
    end

    it "contains two code blocks" do
      expect(example.parsed_code.size).to eq 2
    end

    it "contains a first block with no comments" do
      code_block = example.parsed_code.first
      expect(code_block.comment).to be_empty
      expect(code_block.code.size).to eq 1
      expect(code_block.code.first).to eq "puts \"Hello, World!\""
    end

    it "contains a second block with no comments" do
      code_block = example.parsed_code[1]
      expect(code_block.comment.size).to eq 2
      expect(code_block.comment[0]).to eq "This comment will initiate"
      expect(code_block.comment[1]).to eq "a new block"
      expect(code_block.code.size).to eq 1
      expect(code_block.code.first).to eq 'puts "Goodbye"'
    end
  end
end
