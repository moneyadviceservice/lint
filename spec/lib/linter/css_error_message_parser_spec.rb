require 'spec_helper'

describe Linter::CssErrorMessageParser do
  let(:parser) { Linter::CssErrorMessageParser.new(File.open('spec/fixtures/errors.css')) }
  let(:raw_error) do
    {
      "type"    => "warning",
      "line"    => 1,
      "col"     => 2,
      "message" => "Rule is empty.",
      "evidence"=> "body {",
      "rule" => {
       "id"       => "empty-rules",
       "name"     => "Disallow empty rules",
       "desc"     => "Rules without any properties specified should be removed.",
       "browsers" => "All"
      }
    }
  end

  describe "parses correctly a css error message" do

    before do
      parser.parse(raw_error)
    end

    it 'has a type' do
      expect(parser.type).to eq('warning')
    end

    it 'has a line' do
      expect(parser.line).to eq(1)
    end

    it 'has a col' do
      expect(parser.col).to eq(2)
    end

    it 'has a message' do
      expect(parser.message).to eq('Rule is empty.')
    end

    it 'has an evidence' do
      expect(parser.evidence).to eq('body {')
    end

    it 'has an hint' do
      expect(parser.hint).to eq('Rules without any properties specified should be removed.')
    end

    it 'has a browsers' do
      expect(parser.browsers).to eq('All')
    end
  end
end
