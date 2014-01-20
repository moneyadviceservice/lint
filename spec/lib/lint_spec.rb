require 'spec_helper'

describe Lint::RackMiddleware do

  let(:env)        { Sprockets::Environment.new('spec/fixtures/server') }
  let(:valid_js)   do
    Sprockets::ProcessedAsset.new(
      env, 'app.js', fixtures_path('server/app/assets/javascripts/app.js'))
  end
  let(:invalid_js) do
    Sprockets::ProcessedAsset.new(
      env, 'invalid.js', fixtures_path('server/app/assets/javascripts/invalid.js'))
  end

  before do
    allow(Rails).to receive(:root).and_return(Pathname.new(env.root))
    env.append_path('app/assets/javascripts')
  end

  describe 'With no linting errors' do
    let(:inner_app) do
      lambda do |env|
        [
         200,
         {'Content-Type' => 'text/javascripts'},
         Rack::BodyProxy.new(valid_js) {}
        ]
      end
    end
    let(:app) { Lint::RackMiddleware.new(inner_app, env)}

    it 'serves assets normally' do
      get '/app.js'
      expect(last_response).to be_ok
      expect(last_response.body).to eq(valid_js.body)
    end
  end

  describe 'With linting errors' do
    let(:inner_app) do
      lambda do |env|
        [
         200,
         {'Content-Type' => 'text/javascripts'},
         Rack::BodyProxy.new(invalid_js) {}
        ]
      end
    end
    let(:app) { Lint::RackMiddleware.new(inner_app, env)}

    describe 'When checking javascript files' do


      it 'modifies the content to display the errors' do
        root = File.expand_path('.')
        get '/invalid.js'
        expect(last_response).to be_ok
        expect(last_response.body).to eq("throw Error(\"StandardError: #{root}/spec/fixtures/server/app/assets/javascripts/invalid.js:2:15\\n\\t    return bar\\nError: Missing semicolon.\\n#{root}/spec/fixtures/server/app/assets/javascripts/invalid.js:4:1\\n\\t;\\nError: Unnecessary semicolon.\")")
      end
    end
  end
end
