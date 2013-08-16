ENV['RACK_ENV'] = 'test'

require 'greenroom'
require 'rspec'
require 'rack/test'
require 'json'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'Greenroom App' do
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
