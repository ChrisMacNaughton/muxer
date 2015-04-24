require 'spec_helper'

RSpec.describe Muxer::Request do
  let(:request) { Muxer::Request.new }
  let(:multiplexer) { Muxer::Multiplexer.new }
  
  it 'has a url' do
    request.url = 'https://www.google.com'

    expect(request.url).to eq('https://www.google.com')
  end

  it 'has a timeout' do
    request.timeout = 10

    expect(request.timeout).to eq(10)
  end

  it 'has headers' do
    request.headers[:api_key] = "test1234"

    expect(request.headers).to be_kind_of(Hash)
    expect(request.headers).to eq({api_key: 'test1234'})
  end

  it 'has an id' do
    request.id = :test

    expect(request.id).to eq(:test)
  end

  it 'knows how long the request took' do
    request.url = 'https://www.google.com'
    VCR.use_cassette('muxer/request/runtime') do
      multiplexer.add_request(request)
      response = multiplexer.execute

      response = response[:succeeded][0]

      expect(response.runtime).to be_kind_of(Float)
    end
  end

  describe :method do
    it 'has a valid method' do
      request.method = 'POST'

      expect(request.method).to eq(:post)
    end

    it 'does not have an invalid method' do
      request.method = "WRONG"

      expect(request.method).to eq(:get)
    end
  end
end