require 'spec_helper'

RSpec.describe Muxer, "execute" do

  it 'can make a web request' do
    VCR.use_cassette('muxer/makes_a_web_request') do
      response = Muxer.execute do |muxer|
        muxer.add_url "http://www.rubydoc.info"
      end

      expect(response).to be_kind_of(Hash)
      expect(response[:succeeded]).to be_kind_of(Array)
    end
  end

  it 'can make multiple web requests' do
    VCR.use_cassette('muxer/makes_multiple_web_requests') do
      response = Muxer.execute do |muxer|
        muxer.add_url "http://www.rubydoc.info"
        muxer.add_url "https://www.google.com"
      end

      expect(response).to be_kind_of(Hash)
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(2)
    end
  end

  it 'can have a request fail' do
    VCR.use_cassette('muxer/can_have_a_request_fail', :record => :new_episodes) do
      response = Muxer.execute do |muxer|
        muxer.add_url "http://www.rubydoc.info"
        muxer.add_url "https://www.thisisabadexampledomain.com"
      end

      expect(response).to be_kind_of(Hash)
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(1)

      expect(response[:failed]).to be_kind_of(Array)
      expect(response[:failed].count).to eq(1)
    end
  end


end