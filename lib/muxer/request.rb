module Muxer
  class Request
    attr_accessor :url
    attr_reader :method

    def initialize
      @method = :GET
    end

    def method=(method)
      method = method.downcase.to_sym

      @method = method.upcase if [:get, :post, :head, :options, :put, :delete].include? method
    end
  end
end