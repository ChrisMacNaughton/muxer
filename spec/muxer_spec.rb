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

  it 'can make a request with an id' do
    VCR.use_cassette('muxer/makes_a_web_request') do
      response = Muxer.execute do |muxer|
        muxer.add_url "http://www.rubydoc.info", {id: :rubydoc}
      end

      expect(response[:succeeded_by_id]).to be_kind_of(Array)
      expect(response[:succeeded_by_id][:rubydoc].url).to eq('http://www.rubydoc.info')
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

  it 'can make a POST' do
    VCR.use_cassette('muxer/post/can') do
      response = Muxer.execute do |muxer|
        muxer.add_url 'https://httpbin.org/post', method: :post
      end
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(1)

      response_body = JSON.parse(response[:succeeded][0].response)
      expect(response_body['form']).to eq({})
    end
  end

  it 'can make a POST with params' do
    VCR.use_cassette('muxer/post/with_params') do
      response = Muxer.execute do |muxer|
        muxer.add_url 'https://httpbin.org/post', method: :post, params: {test: :success}
      end
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(1)

      response_body = JSON.parse(response[:succeeded][0].response)
      expect(response_body['form']).to be_kind_of(Hash)
      expect(response_body['form']['test']).to eq('success')
    end
  end

  it 'can make a PUT' do
    VCR.use_cassette('muxer/put/can') do
      response = Muxer.execute do |muxer|
        muxer.add_url 'https://httpbin.org/put', method: :put
      end
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(1)

      response_body = JSON.parse(response[:succeeded][0].response)
      expect(response_body['form']).to eq({})
    end
  end

  it 'can make a PUT with params' do
    VCR.use_cassette('muxer/put/with_params') do
      response = Muxer.execute do |muxer|
        muxer.add_url 'https://httpbin.org/put', method: :put, params: {test: :success}
      end
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(1)

      response_body = JSON.parse(response[:succeeded][0].response)
      expect(response_body['form']).to be_kind_of(Hash)
      expect(response_body['form']['test']).to eq('success')
    end
  end

  it 'can follow redirects' do
    VCR.use_cassette('muxer/redirects/google') do
      response = Muxer.execute do |muxer|
        muxer.add_url 'https://google.com', redirects: 1
      end
      expect(response[:succeeded]).to be_kind_of(Array)
      expect(response[:succeeded].count).to eq(1)

      body = response[:succeeded][0].response
      expect(body).to include('<title>Google</title>')
    end
  end

end