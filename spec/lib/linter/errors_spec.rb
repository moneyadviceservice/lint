require 'spec_helper'

describe Linter::Errors do
  let(:parser)   { Linter::CssErrorMessageParser.new(File.open('spec/fixtures/errors.css')) }
  let(:formater) { Linter::CssErrorFormater.new }
  let(:errors)   { Linter::Errors.new(parser, formater) }
  let(:raw_errors) do
    [
      {
        "type"    => "warning",
        "line"    => 1,
        "col"     => 1,
        "message" =>"Rule is empty.",
        "evidence"=>"body {",
        "rule" => {
          "id"       => "empty-rules",
          "name"     => "Disallow empty rules",
          "desc"     => "Rules without any properties specified should be removed.",
          "browsers" => "All"
        }
      }, {
        "type"     => "error",
        "line"     => 2,
        "col"      => 11,
        "message"  => "Unexpected token ';' at line 2, col 11.",
        "evidence" => "    width:;",
        "rule" => {
          "id"       => "errors",
          "name"     => "Parsing Errors",
          "desc"     => "This rule looks for recoverable syntax errors.",
          "browsers" => "All"
        }
      }
    ]
  end

  describe "When not error messages are returned from a result" do
    it "does not have any errors messages" do
      errors.parse!([])
      expect(errors.full_messages).to be_empty
    end
  end

  describe "When error messages are returned from a result" do
    it "does not have any errors messages" do
      errors.parse!(raw_errors)
      expect(errors.full_messages).not_to be_empty
    end

    describe "When warnings are also returned by the linter" do
      it 'does not include the warnings' do
        errors.parse!(raw_errors)
        expect(errors.full_messages).to eq(["/Users/ymarquet/moneyadvice/mas-lint/spec/fixtures/errors.css:2:11\n\t    width:;\nError: Unexpected token ';' at line 2, col 11.\nHint: This rule looks for recoverable syntax errors.\nAffected browsers: All"])
      end
    end
  end

end
