require 'spec_helper'

RSpec.describe Muxer::Multiplexer do
  let(:multiplexer) { Muxer::Multiplexer.new }

  it 'kills requests with a timeout' do
    VCR.use_cassette('muxer/multiplexer/with_a_timeout') do
      multiplexer.add_url('https://github.com//', 0.0001)
      start = Time.now
      response = multiplexer.execute
      puts "ran in #{Time.now - start} seconds?"

      expect(response[:succeeded].count).to eq(0)
      expect(response[:failed].count).to eq(1)
   end

  end
end