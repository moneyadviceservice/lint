require 'spec_helper'

describe Linter::ErrorMessage do
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
  let(:file)   { File.new('spec/fixtures/errors.css') }
  let(:parser) { Linter::CssErrorMessageParser.new(file) }
  let(:error)  { Linter::ErrorMessage.new(parser.parse(raw_error)) }

  describe "properties" do

    it 'has the file path' do
      expect(error.file_path).to eq(File.expand_path('spec/fixtures/errors.css'))
    end

    it 'has a type' do
      expect(error.type).to eq('warning')
    end

    it 'has a type' do
      expect(error.type).to eq('warning')
    end

    it 'has a line' do
      expect(error.line).to eq(1)
    end

    it 'has a col' do
      expect(error.col).to eq(2)
    end

    it 'has a message' do
      expect(error.message).to eq('Rule is empty.')
    end

    it 'has an evidence' do
      expect(error.evidence).to eq('body {')
    end

    it 'has an hint' do
      expect(error.hint).to eq('Rules without any properties specified should be removed.')
    end

    it 'has a browsers' do
      expect(error.browsers).to eq('All')
    end

  end

  describe '.build' do
    it 'return an array of ErrorMessage instances' do
      collection = Linter::ErrorMessage.from_collection([raw_error], parser)
      expect(collection.first).to be_an_instance_of(Linter::ErrorMessage)
    end
  end
end
