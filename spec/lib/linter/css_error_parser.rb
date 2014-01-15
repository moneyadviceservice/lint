require 'spec_helper'

describe Linter::CssErrorParser do
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
  let(:parser) { Linter::CssErrorParser.new(raw_errors) }

  it 'should parse CSSLint errors' do
    parser.parse!(raw_errors)
    expect(parser.errors).to eq([])
  end
end
