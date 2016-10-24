# -*- encoding: utf-8 -*-
require 'rack/test'
require 'rspec/its'
require 'tapp'
require 'simplecov'
require 'rack-server-pages'
SimpleCov.start

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.raise_errors_for_deprecations!
end

require 'tilt'
require 'slim'
Tilt.register Tilt::ERBTemplate, 'php'

def app
  @app ||= Rack::Builder.app do
    run Rack::ServerPages
  end
end

def mock_app(&block)
  @app = Rack::Builder.app(&block)
end

def should_be_ok(path)
  context "GET #{path}" do
    let(:path_info) { path }
    it { is_expected.to be_ok }
    its(:content_type) { should match /\b#{content_type}\b/ }
  end
end

def should_be_not_found(path)
  context "GET #{path}" do
    let(:path_info) { path }
    it { is_expected.to be_not_found }
    # its(:content_type) { should eq 'text/plain' }
  end
end
