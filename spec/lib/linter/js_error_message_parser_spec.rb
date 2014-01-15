require 'spec_helper'

describe Linter::JsErrorMessageParser do
  let(:parser) { Linter::JsErrorMessageParser.new(File.open('spec/fixtures/errors.js')) }
  let(:raw_error) do
    {
     "id"        => "(error)",
     "raw"       => "Expected '{a}' and instead saw '{b}'.",
     "evidence"  => "        return 'bar'",
     "line"      => 6,
     "character" => 21,
     "a"         => ";",
     "b"         => "}",
     "reason"    => "Expected ';' and instead saw '}'."
    }
  end

  describe "parses correctly a js error message" do
    before do
      parser.parse(raw_error)
    end

    it 'has a type' do
      expect(parser.type).to eq('error')
    end

    it 'has a line' do
      expect(parser.line).to eq(6)
    end

    it 'has a col' do
      expect(parser.col).to eq(21)
    end

    it 'has a message' do
      expect(parser.message).to eq("Expected ';' and instead saw '}'.")
    end

    it 'has an evidence' do
      expect(parser.evidence).to eq("        return 'bar'")
    end

  end
end
