require 'eventmachine'
require 'em-http'

require 'muxer/version'
require 'muxer/request'
require 'muxer/multiplexer'

# Muxer is a parallel request module that allows timeouts for each
# individual request as well as a global timeout for all requests.
# In addition to the specific timeouts, Muxer will allow a pending
# request to continue pending even if its timeout has passed as long
# as there is still a request waiting that has a longer timeout

# Example Usage:

# response = Muxer.execute do |muxer|
#   muxer.add_url "http://www.rubydoc.info", timeout: 0.5
#   muxer.add_url "https://www.google.com", timeout: 0.25
# end

# In the above example, Google's response could continue pending if
# rubydoc.info had not yet returned or passed its timeout.

# Returns a hash like:
# ```ruby
# {
#   failed: [],
#   completed: []
# }
# ```

module Muxer
  def self.execute
    multiplexer = Multiplexer.new

    yield multiplexer if block_given?

    multiplexer.execute
  end
end
