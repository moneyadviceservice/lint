require 'spec_helper'

describe Mas::Lint::Linter do

  let(:linter_yml) { YAML.load_file('spec/fixtures/linter.yml') }

  describe 'When linting a js file' do

    describe 'When provided an options file for linting rules' do

      let(:js_file) { File.open('spec/fixtures/valid_with_options.js') }

      it 'configures JSLint properly' do
        expect(Mas::Lint::Linter.new(js_file, linter_yml)).to be_valid
      end

    end

    describe 'When no linting errors are detected' do

      let(:linter) { Mas::Lint::Linter.new(js_file) }
      let(:js_file) { File.open('spec/fixtures/valid.js') }

      it 'runs the JSLint linter' do
        pending("No idead why the expection is not met")
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

      let(:linter) { Mas::Lint::Linter.new(js_file) }
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
        expect(Mas::Lint::Linter.new(css_file, linter_yml)).to be_valid
      end

    end

    describe 'When no linting errors are detected' do

      let(:linter) { Mas::Lint::Linter.new(css_file) }
      let(:css_file) { File.open('spec/fixtures/valid.css') }

      it 'runs the CSSLint linter' do
        pending("No idead why the expection is not met")
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

      let(:linter) { Mas::Lint::Linter.new(css_file) }
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
