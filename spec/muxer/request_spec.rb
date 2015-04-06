require 'spec_helper'

RSpec.describe Muxer::Request do
  let(:request) { Muxer::Request.new }

  it 'has a url' do
    request.url = 'https://www.google.com'

    expect(request.url).to eq('https://www.google.com')
  end

  it 'has headers'

  describe :method do
    it 'has a valid method' do
      request.method = 'POST'

      expect(request.method).to eq(:POST)
    end

    it 'does not have an invalid method' do
      request.method = "WRONG"

      expect(request.method).to eq(:GET)
    end
  end
end