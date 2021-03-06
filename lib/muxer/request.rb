module Muxer
  # Muxer::Request is designed to wrap the requests that Muxer uses
  # to parallelize the web requests and handle timeouts.
  #
  # @!attribute url
  #   @return [String] URL to use
  # @!attribute timeout
  #   @return [Number] Seconds for the timeout
  # @!attribute headers
  #   @return [Hash] Request headers to use with the request
  # @!attribute params
  #   @return [Hash] request parameters
  # @!attribute redirects
  #   @return [Integer] How many redirects to follow
  # @!attribute method
  #   @return [Symbol] HTTP method to use
  # @!attribute completed
  #   @return [Boolean] Is the request completed
  # @!attribute error
  #   @return [Boolean] Have we had an error?
  # @!attribute id
  #   @return [Symbol] ID for this request, the ID is arbitrary and to
  #   be assigned by the user
  # @!attribute runtime
  #   @return  [Float] Runtime for the request
  class Request
    attr_accessor :url, :timeout, :headers, :params, :redirects, :id
    attr_reader :method, :completed, :error, :runtime

    alias_method  :completed?, :completed
    def initialize
      @method = :get
      @completed = false
      @timeout = 10
      @headers = {}
      @params = {}
      @request = nil
      @error = nil
    end

    # sets the HTTP method of the request as long as the method
    # is one off the standard http methods. The method can be sent
    # in as a string or a symbol.
    # The valid options are:
    # :get, :post, :head, :options, :put, :delete
    #
    # @param method [string, symbol] HTTP Method of the request
    # @return true
    def method=(method)
      method = method.downcase.to_sym

      @method = method if [:get, :post, :head, :options, :put, :delete].include? method
      true
    end

    # process! executes the web request. It cannot be called from
    # outside of an EventMachine loop.
    #
    # @return self
    def process!
      @start = Time.now
      http = EventMachine::HttpRequest.new(url,
        connect_timeout: timeout,
        inactivity_timeout: timeout,
      )

      @request = http.public_send(method,
        request_options
      )

      @request.callback { @completed = true; @runtime = Time.now - @start; @start = nil }
      @request.errback { @completed = @error = true; @runtime = Time.now - @start; @start = nil}
      self
    end

    # response is the actual http request's response. 
    def response
      if @request
        @request.response
      end
    end

    private

    def request_options
      options = {
        head: headers
      }
      if [:post, :put].include? method
        options[:body] = params
      else
        options[:query] = params
      end

      options[:redirects] = redirects
      options.reject!{|_,v| empty? v}
      options
    end

    def empty?(opt)
      (opt.nil? || opt == {} || opt == [] || opt == '')
    end
  end
end