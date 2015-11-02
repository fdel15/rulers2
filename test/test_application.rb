require_relative "test_helper"

class TestApp < Rulers2::Application
end

class RulersAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_array_sum
    a = [1,2,3,4]
    b = ["hi", "bye"]

    assert_equal a.sum, 10
    assert_equal a.sum(10), 20
    assert_nil b.sum
  end

  def test_array_print
    a = [1,2,3,4]
    assert_equal a.print, "The sum of the elements is #{a.sum}"
  end
end