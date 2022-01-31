# frozen_string_literal: true

# $LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'test/unit'
require 'colrapi'
require 'vcr'

# TODO: remove
require 'byebug'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end