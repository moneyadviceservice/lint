require 'spec_helper'

describe Mas::Lint::Errors do
  let(:parser)   { Mas::Lint::CssErrorParser.new }
  let(:formater) { Mas::Lint::CssErrorFormater.new }
  let(:errors)   { Mas::Lint::Errors.new(File.new('spec/fixtures/errors.css'), parser, formater) }
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
  let(:linter_result) { CSSLint::Result.new(raw_errors) }

  describe "When not error messages are return from a result" do
    it "does not have any errors messages" do
      errors.parse!(linter_result)
      expect(errors.full_messages).to be_empty
    end
  end

end
