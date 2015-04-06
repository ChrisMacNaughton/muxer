require 'spec_helper'

RSpec.describe Muxer, "execute" do

  it 'can make a web request' do
    response = Muxer.execute do |muxer|
      muxer.add_url "https://www.google.com"
    end

    expect(response).to be_kind_of(Array)
  end


end