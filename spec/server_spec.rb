ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'greenroom'
require 'json'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'Greenroom Server' do
  def app
    Sinatra::Application
  end

  it "pings" do
    post '/rpcutil/ping'
    ret = JSON.parse(last_response.body)

    last_response.should be_ok
    ret[0]["statusmsg"].should == 'OK'
  end

  it "fetches inventory" do
    post '/rpcutil/inventory'
    ret = JSON.parse(last_response.body)

    last_response.should be_ok
    ret[0]["statusmsg"].should == 'OK'
  end
end
