require 'spec_helper'

describe Linter::CssErrorFormater do
  let(:css_file) { File.open('spec/fixtures/errors.js') }
  let(:parser)   { Linter::CssErrorMessageParser.new(css_file)}
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

  let(:error_message) { Linter::ErrorMessage.new(parser.parse(raw_error)) }
  let(:formater)      { Linter::CssErrorFormater.new}
  it 'format nicely errors' do
    message = "#{error_message.file_path}:1:2\n\tbody {\nWarning: Rule is empty.\nHint: Rules without any properties specified should be removed.\nAffected browsers: All"
    expect(formater.format([error_message])).to eq([message])

  end
end
