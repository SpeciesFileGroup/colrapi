# frozen_string_literal: true

require "erb"
require_relative "colrapi/version"
require_relative "colrapi/request"
require "colrapi/helpers/configuration"

module Colrapi
  extend Configuration

  define_setting :base_url, "https://api.catalogueoflife.org/"
  define_setting :mailto, ENV["COL_API_EMAIL"]

  # Search the nameusage route
  #
  # @param q [String] A query string
  # @param endpoint [String, nil] some endpoints have nested options
  # @param rank [String, nil] taxonomic rank of the name usage

  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array] An array of hashes
  def self.nameusage(q: nil, endpoint: 'nameusage/search', rank: nil, offset: 0, limit: 10, verbose: false)
    Request.new(endpoint, q, rank, offset, limit, verbose).perform
  end

end
