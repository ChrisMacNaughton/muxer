require 'spec_helper'

RSpec.describe Muxer::Multiplexer do
  let(:multiplexer) { Muxer::Multiplexer.new }

  it 'kills requests with a timeout' do
    VCR.use_cassette('muxer/multiplexer/with_a_timeout') do
      multiplexer.add_url('https://github.com//', 0.0001)
      response = multiplexer.execute

      expect(response[:succeeded].count).to eq(0)
      expect(response[:failed].count).to eq(1)
   end
  end

  it 'lets a request wait on the longer one' do
    VCR.use_cassette('muxer/multiplexer/with_one_timeout') do
      multiplexer.add_url('https://github.com/', 0.0001)
      multiplexer.add_url('https://codeclimate.com/', 2)
      response = multiplexer.execute

      expect(response[:succeeded].count).to eq(2)
      expect(response[:failed].count).to eq(0)
    end
  end

  it 'kills requests with a global timeout' do
    VCR.use_cassette('muxer/multiplexer/with_a_global_timeout') do
      multiplexer.add_url('https://github.com/')
      multiplexer.timeout = 0.0001
      response = multiplexer.execute

      expect(response[:succeeded].count).to eq(0)
      expect(response[:failed].count).to eq(1)
    end
  end

  it 'kills one of two requests with a global timeout' do
    VCR.use_cassette('muxer/multiplexer/with_global_timeout') do
      multiplexer.add_url('https://github.com/')
      multiplexer.add_url('https://www.google.com/')
      multiplexer.timeout = 0.2
      response = multiplexer.execute

      expect(response[:succeeded].count).to eq(1)
      expect(response[:failed].count).to eq(1)
    end
  end
end