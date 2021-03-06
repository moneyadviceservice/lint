require 'spec_helper'

shared_examples_for 'css linter provider' do
  it 'provides a css linter' do
    expect(Lint::Linter.for('some/css/file.css.scss.erb')).to be_a(Lint::Css)
  end

end
shared_examples_for 'js linter provider' do
  it 'provides a js linter' do
    expect(Lint::Linter.for('some/js/file.js.coffee.erb')).to be_a(Lint::Js)
  end
end


describe Lint::Linter do

  let(:linter_yml) { YAML.load_file('spec/fixtures/linter.yml') }

  before do
    Lint::Linter.configure do |config|
      config.csslint_rules = linter_yml['css']
      config.jshint_rules  = linter_yml['js']
    end
  end

  describe 'Abstract interface' do
    %w(formater parser linter linter_function).each do |method_name|
      it "##{method_name} raises a NoMethodError" do
        expect { Lint::Linter.new('some/file.css').send(method_name) }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.for' do
    describe 'And providing a file path string' do
      describe 'For a css like file' do
        let(:file) { 'path/to/css/file.css' }
        it_behaves_like 'css linter provider'
      end

      describe 'For a js like file' do
        let(:file) { 'path/to/js/file.js' }
        it_behaves_like 'js linter provider'
      end
    end

    describe 'And providing a file as an argument' do
      describe 'For a css like file' do
        let(:file) { File.open('spec/fixtures/file.css.scss.erb')}
        it_behaves_like 'css linter provider'
      end

      describe 'For a js like file' do
        let(:file) { File.open('spec/fixtures/file.js.coffee.erb')}
        it_behaves_like 'js linter provider'
      end
    end

  end


  describe 'When linting a js file' do

    describe 'When provided an options file for linting rules' do

      let(:js_file) { File.open('spec/fixtures/valid_with_options.js') }

      it 'configures JSLint properly' do
        expect(Lint::Linter.for(js_file)).to be_valid
      end

    end

    describe 'When no linting errors are detected' do

      let(:linter) { Lint::Linter.for(js_file) }
      let(:js_file) { File.open('spec/fixtures/valid.js') }

      it 'runs the JSLint linter' do
        pending("No idea why the expectation is not met")
        expect(JSLint.context).to receive(:call).with('JSLINTR', File.open('spec/fixtures/valid.js').read, {})
        linter.valid?
      end

      it 'is valid' do
        expect(linter).to be_valid
      end

      it 'does not have errors' do
        expect(linter.errors.full_messages).to eq([])
      end
    end

    describe 'When linting errors are detected' do

      let(:linter) { Lint::Linter.for(js_file) }
      let(:js_file) { File.open('spec/fixtures/errors.js') }

      it 'is not valid' do
        expect(linter).not_to be_valid
      end

      it 'has errors' do
        linter.valid?
        expect(linter.errors.full_messages).not_to be_empty
      end
    end
  end

  describe 'When Linting a css file' do

    describe 'When provided an options file for linting rules' do

      let(:css_file) { File.open('spec/fixtures/valid_with_options.css') }

      it 'configures CSSLint properly' do
        expect(Lint::Linter.for(css_file)).to be_valid
      end

    end

    describe 'When no linting errors are detected' do

      let(:linter) { Lint::Css.new(css_file) }
      let(:css_file) { File.open('spec/fixtures/valid.css') }

      it 'runs the CSSLint linter' do
        pending("No idead why the expectation is not met")
        expect(CSSLint.context).to receive(:call).with('CSSLINTR', File.open('spec/fixtures/valid.css').read, {}).and_call_original
        linter.valid?
      end

      it 'is valid' do
        expect(linter).to be_valid
      end

      it 'does not have errors' do
        linter.valid?
        expect(linter.errors.full_messages).to eq([])
      end
    end

    describe 'When linting errors are detected' do

      let(:linter) { Lint::Linter.for(css_file) }
      let(:css_file) { File.open('spec/fixtures/errors.css') }

      it 'is not valid' do
        expect(linter).not_to be_valid
      end

      it 'has errors' do
        linter.valid?
        expect(linter.errors.full_messages).not_to be_empty
      end
    end
  end
end
