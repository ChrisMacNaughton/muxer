require 'spec_helper'

class Muxer::TestRequest < Muxer::Request
  def test_timeout=(timeout)
    @test_timeout = timeout
  end

  def test_timeout
    @test_timeout ||= 0.0001
  end

  def process!
    EM::Timer.new(test_timeout) do
      @completed = true
    end

    return self
  end

end
RSpec.describe Muxer::Multiplexer do

  def new_request(url, timeout = nil, test_timeout = nil)
    request = Muxer::TestRequest.new
    request.url = url
    request.timeout = timeout if timeout
    request.test_timeout = test_timeout if test_timeout
    request
  end

  let(:multiplexer) { Muxer::Multiplexer.new }

  it 'kills requests with a timeout' do
    multiplexer.add_request(new_request('https://github.com/', 0.0001, 0.01))
    response = multiplexer.execute

    expect(response[:succeeded].count).to eq(0)
    expect(response[:failed].count).to eq(1)
  end

  it 'lets a request wait on the longer one' do
    multiplexer.add_request(new_request('https://github.com/', 0.0001, 0.0002))
    multiplexer.add_request(new_request('https://codeclimate.com/', 2, 0.002))
    response = multiplexer.execute

    expect(response[:succeeded].count).to eq(2)
    expect(response[:failed].count).to eq(0)
  end

  it 'kills requests with a global timeout' do
    multiplexer.add_request(new_request('https://github.com/', nil, 0.002))
    multiplexer.timeout = 0.0001
    response = multiplexer.execute

    expect(response[:succeeded].count).to eq(0)
    expect(response[:failed].count).to eq(1)
  end

  it 'kills one of two requests with a global timeout' do
    multiplexer.add_request(new_request('https://github.com/', nil, 1.0))
    multiplexer.add_request(new_request('https://www.google.com/', nil, 0.00001))
    multiplexer.timeout = 0.0001
    response = multiplexer.execute

    expect(response[:succeeded].count).to eq(1)
    expect(response[:failed].count).to eq(1)
  end
end