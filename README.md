# Muxer

[![Quality](https://img.shields.io/codeclimate/github/ChrisMacNaughton/muxer.svg?style=flat-square)](https://codeclimate.com/github/ChrisMacNaughton/muxer)
[![Coverage](https://img.shields.io/codeclimate/coverage/github/ChrisMacNaughton/muxer.svg?style=flat-square)](https://codeclimate.com/github/ChrisMacNaughton/muxer)
[![Build](https://img.shields.io/travis-ci/ChrisMacNaughton/muxer.svg?style=flat-square)](https://travis-ci.org/ChrisMacNaughton/muxer)
[![Dependencies](https://img.shields.io/gemnasium/ChrisMacNaughton/muxer.svg?style=flat-square)](https://gemnasium.com/ChrisMacNaughton/muxer)
[![Docs](https://inch-ci.org/github/ChrisMacNaughton/muxer.svg?branch=master)](http://inch-ci.org/github/ChrisMacNaughton/muxer/branch/master)
[![Issues](https://img.shields.io/github/issues/ChrisMacNaughton/muxer.svg?style=flat-square)](https://github.com/ChrisMacNaughton/muxer/issues)
[![Downloads](https://img.shields.io/gem/dtv/muxer.svg?style=flat-square)](https://rubygems.org/gems/muxer)
[![Tags](https://img.shields.io/github/tag/ChrisMacNaughton/muxer.svg?style=flat-square)](https://github.com/ChrisMacNaughton/muxer/tags)
[![Releases](https://img.shields.io/github/release/ChrisMacNaughton/muxer.svg?style=flat-square)](https://github.com/ChrisMacNaughton/muxer/releases)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/gem/v/muxer.svg?style=flat-square)](https://rubygems.org/gems/muxer)

Muxer is a gem to allow web requests to run in parallel with seperate timeouts per request, in addition to an optional global timeout for all of the requests.

For example:

- Request 1 (Internal API) - 5 second timeout
- Request 2 (External) - 1 second timeout
- Request 3 (External) - 1 second timeout
- Request 4 (External) - 1 second timeout

Requests 2-4 will be allowed to continue waiting after their timeouts if we are still waiting on Request 1; however, if Request 1 comes back in half a second, we will finish ALL requests at the 1 second timeout. Any requests not finished within the timeouts will be added to the :failed array in the response.

## Installation

Add this line to your application's Gemfile:

    gem 'muxer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install muxer

## Usage

```
response = Muxer.execute do |muxer|
  muxer.add_url "http://www.rubydoc.info"
  muxer.add_url "https://www.google.com"
end

response[:failed] == []
response[:succeeded] == [
  Muxer::Request(url: "http://www.rubydoc.info"),
  Muxer::Request(url: "https://www.google.com")
]
```
## Contributing

1. Fork it ( https://github.com/[my-github-username]/muxer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
