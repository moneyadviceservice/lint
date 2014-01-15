require 'spec_helper'

describe Mas::Lint::Linter do
  describe 'When linting a js file' do

    let(:linter) { Mas::Lint::Linter.new(js_file) }


    describe 'When no linting errors are detected' do

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

      let(:js_file) { File.open('spec/fixtures/errors.js') }

      it 'is not valid' do
        expect(linter).not_to be_valid
      end

      it 'has errors' do
        expect(linter.errors.full_messages).to eq(['an error'])
      end
    end
  end

  describe 'When Linting a css file' do

    let(:linter) { Mas::Lint::Linter.new(css_file) }

    describe 'When no linting errors are detected' do

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

      let(:css_file) { File.open('spec/fixtures/errors.css') }

      it 'is not valid' do
        expect(linter).not_to be_valid
      end

      it 'has errors' do
        linter.valid?
        expect(linter.errors.full_messages).to eq(['an error'])
      end
    end
  end
end
