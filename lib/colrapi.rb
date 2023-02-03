# frozen_string_literal: true

require "erb"
require_relative "colrapi/version"
require_relative "colrapi/request"
require "colrapi/helpers/configuration"

module Colrapi
  extend Configuration

  define_setting :base_url, "https://api.checklistbank.org/"
  define_setting :mailto, ENV["COL_API_EMAIL"]

  # Get names or a name from a dataset
  #
  # @param dataset_id [String] The dataset id
  # @param name_id [String] The name id
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.name(dataset_id, name_id: nil, subresource: nil, offset: 0, limit: 10, verbose: false)
    endpoint = "dataset/#{dataset_id}/name"
    unless name_id.nil?
      endpoint = "#{endpoint}/#{name_id}"
      offset = nil
      limit = nil
    end
    if !subresource.nil? and %w[relations synonyms types orphans].include? subresource
      endpoint = "#{endpoint}/#{subresource}"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Search the nameusage route
  #
  # @param q [String] A query string
  # @param dataset_id [String, nil] restricts name usage search within a dataset
  # @param endpoint [String, nil] some endpoints have nested options
  # @param content [String, nil] restrict search to SCIENTIFIC_NAME, or AUTHORSHIP
  # @param type [String, nil] sets the type of search to PREFIX, WHOLE_WORDS, or EXACT
  # @param rank [String, nil] taxonomic rank of name usages
  # @param min_rank [String, nil] minimum taxonomic rank of name usages
  # @param max_rank [String, nil] maximum taxonomic rank of name usages
  # @param sort_by [String, nil] sort results by NAME, TAXONOMIC, INDEX_NAME_ID, NATIVE, or RELEVANCE

  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.nameusage_search(q: nil, dataset_id: nil, endpoint: 'nameusage/search', content: nil, type: nil,
                            rank: nil, min_rank: nil, max_rank: nil, sort_by: nil, offset: 0, limit: 10, verbose: false)

    # a nil dataset_id will search name usages from all datasets in ChecklistBank
    unless dataset_id.nil?
      endpoint = "dataset/#{dataset_id}/nameusage/search"
    end

    Request.new(endpoint: endpoint, q: q, content: content, type: type,
                rank: rank, min_rank: min_rank, max_rank: max_rank,
                sort_by: sort_by, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get the full list of taxon IDs for a dataset (returns 1 ID string per line, not JSON)
  #
  # @param dataset_id [String] The dataset id
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_ids(dataset_id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/ids", verbose: verbose).perform
  end

  # Get a taxon with @id from dataset @dataset_id via the taxon route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}", verbose: verbose).perform
  end

  # Get the classification for a taxon with @id from dataset @dataset_id via the taxon classification route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_classification(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/classification", verbose: verbose).perform
  end

  # Get the asserted distribution for a taxon with @id from dataset @dataset_id via the taxon distribution route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_distribution(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/distribution", verbose: verbose).perform
  end

  # Get info for a taxon with @id from dataset @dataset_id via the taxon info route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_info(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/info", verbose: verbose).perform
  end

  # Get biological interactions for a taxon with @id from dataset @dataset_id via the taxon interactions route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_interaction(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/interaction", verbose: verbose).perform
  end

  # Get media for a taxon with @id from dataset @dataset_id via the taxon media route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_media(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/media", verbose: verbose).perform
  end

  # Get relations for a taxon with @id from dataset @dataset_id via the taxon relation route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_relation(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/relation", verbose: verbose).perform
  end

  # Get sources for a taxon with @id from dataset @dataset_id via the taxon source route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_source(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/source", verbose: verbose).perform
  end

  # Get synonyms for a taxon with @id from dataset @dataset_id via the taxon synonyms route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_synonyms(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/synonyms", verbose: verbose).perform
  end

  # Get the treatment for a taxon with @id from dataset @dataset_id via the taxon treatment route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_treatment(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/treatment", verbose: verbose).perform
  end

  # Get the vernacular names for a taxon with @id from dataset @dataset_id via the taxon vernacular route
  #
  # @param dataset_id [String] The dataset id
  # @param id [String] The taxon id
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_vernacular(dataset_id, id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/#{id}/vernacular", verbose: verbose).perform
  end

  # Get the root taxa
  #
  # @param dataset_id [String] The dataset id
  # @param taxon_id [String] The taxon id
  # @param children [Boolean] Display the children of taxon_id
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.tree(dataset_id, taxon_id: nil, children: false, offset: 0, limit: 10, verbose: false)
    endpoint = "dataset/#{dataset_id}/tree"
    endpoint = "#{endpoint}/#{taxon_id}" unless taxon_id.nil?
    endpoint = "#{endpoint}/children" unless taxon_id.nil? or !children

    if !taxon_id.nil? and !children
      limit = nil
      offset = nil
    end

    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

end
