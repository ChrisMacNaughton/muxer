module Muxer
  class Request
    attr_accessor :url, :timeout, :headers
    attr_reader :method

    def initialize
      @method = :GET
      @timeout = nil
      @headers = {}
    end

    def method=(method)
      method = method.downcase.to_sym

      @method = method.upcase if [:get, :post, :head, :options, :put, :delete].include? method
    end
  end
end