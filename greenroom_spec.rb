require 'greenroom'
require 'test/unit'
require 'rack/test'
require 'json'

ENV['RACK_ENV'] = 'test'

class GreenroomTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_pings
    get '/rpcutil/ping'
    ret = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal "OK", ret[0]["statusmsg"]
  end

  def test_it_gets_inventory
    get '/rpcutil/inventory'
    ret = JSON.parse(last_response.body)

    assert last_response.ok?
    assert_equal "OK", ret[0]["statusmsg"]
  end
end