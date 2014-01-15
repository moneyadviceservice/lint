require 'spec_helper'

describe Mas::Lint::CssErrorFormater do
  let(:css_file) { File.open('spec/fixtures/errors.js') }
  let(:parser)   { Mas::Lint::CssErrorMessageParser.new(css_file)}
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

  let(:error_message) { Mas::Lint::ErrorMessage.new(parser.parse(raw_error)) }
  let(:formater)      { Mas::Lint:: CssErrorFormater.new}
  it 'format nicely errors' do
    message = "#{error_message.file_path}:1:2\n\tbody {\nError: Rule is empty.\nHint: Rules without any properties specified should be removed.\nAffected browsers: All"
    expect(formater.format([error_message])).to eq([message])

  end
end
