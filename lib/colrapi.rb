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
  # @param name [String] The scientific name to match
  # @param authorship [String] The authorship string for the scientific name
  # @param code [String] The nomenclatural code (bacterial, botanical, cultivars, phytosociological, virus, zoological)
  # @param rank [String] The rank of the scientific name
  # @param within_superkingdom [String] Restricts query to within a superkingdom
  # @param within_kingdom [String] Restricts query to within a kingdom
  # @param within_subkingdom [String] Restricts query to within a subkingdom
  # @param within_superphylum [String] Restricts query to within a superphylum
  # @param within_phylum [String] Restricts query to within a phylum
  # @param within_subphylum [String] Restricts query to within a subphylum
  # @param within_superclass [String] Restricts query to within a superclass
  # @param within_class [String] Restricts query to within a class
  # @param within_subclass [String] Restricts query to within a subclass
  # @param within_superorder [String] Restricts query to within a superorder
  # @param within_order [String] Restricts query to within a order
  # @param within_suborder [String] Restricts query to within a suborder
  # @param within_superfamily [String] Restricts query to within a superfamily
  # @param within_family [String] Restricts query to within a family
  # @param within_subfamily [String] Restricts query to within a subfamily
  # @param within_tribe [String] Restricts query to within a tribe
  # @param within_subtribe [String] Restricts query to within a subtribe
  # @param within_genus [String] Restricts query to within a genus
  # @param within_subgenus [String] Restricts query to within a subgenus
  # @param within_section [String] Restricts query to within a section
  # @param within_species [String] Restricts query to within a species
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.matching(dataset_id, name: nil, authorship: nil, code: nil, rank: nil, within_superkingdom: nil,
                    within_kingdom: nil, within_subkingdom: nil, within_superphylum: nil, within_phylum: nil,
                    within_subphylum: nil, within_superclass: nil, within_class: nil, within_subclass: nil,
                    within_superorder: nil, within_order: nil, within_suborder: nil, within_superfamily: nil,
                    within_family: nil, within_subfamily: nil, within_tribe: nil, within_subtribe: nil,
                    within_genus: nil, within_subgenus: nil, within_section: nil, within_species: nil,
                    verbose: false)
    endpoint = "dataset/#{dataset_id}/matching"
    Request.new(endpoint: endpoint, name: name, authorship: authorship, code: code, rank: rank,
                within_superkingdom: within_superkingdom, within_kingdom: within_kingdom,
                within_subkingdom: within_subkingdom, within_superphylum: within_superphylum,
                within_phylum: within_phylum, within_subphylum: within_subphylum, within_superclass: within_superclass,
                within_class: within_class, within_subclass: within_subclass, within_superorder: within_superorder,
                within_order: within_order, within_suborder: within_suborder, within_superfamily: within_superfamily,
                within_family: within_family, within_subfamily: within_subfamily, within_tribe: within_tribe,
                within_subtribe: within_subtribe, within_genus: within_genus, within_subgenus: within_subgenus,
                within_section: within_section, within_species: within_species, verbose: verbose).perform
  end

  # Get names or a name from a dataset
  #
  # @param dataset_id [String] The dataset id
  # @param name_id [String] The name id
  # @param subresource [String] The name subresource endpoint (relations, synonyms, types, or orphans)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.name(dataset_id, name_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
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
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.nameusage_search(q: nil, dataset_id: nil, endpoint: 'nameusage/search', content: nil, type: nil,
                            rank: nil, min_rank: nil, max_rank: nil, sort_by: nil, offset: nil, limit: nil,
                            verbose: false)

    # a nil dataset_id will search name usages from all datasets in ChecklistBank
    unless dataset_id.nil?
      endpoint = "dataset/#{dataset_id}/nameusage/search"
    end

    Request.new(endpoint: endpoint, q: q, content: content, type: type,
                rank: rank, min_rank: min_rank, max_rank: max_rank,
                sort_by: sort_by, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get a reference with @reference_id from dataset @dataset_id via the reference route
  #
  # @param dataset_id [String] The dataset id
  # @param reference_id [String] The reference id
  # @param subresource [String] The reference subresource endpoint (orphans)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.reference(dataset_id, reference_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/reference"
    if subresource == 'orphans'
      reference_id = nil
      endpoint = "#{endpoint}/orphans"
    end
    unless reference_id.nil?
      endpoint = "#{endpoint}/#{reference_id}"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get a synonym with @synonym_id from dataset @dataset_id via the synonym route
  #
  # @param dataset_id [String] The dataset id
  # @param synonym_id [String] The synonym id
  # @param subresource [String] The synonym subresource endpoint (source)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.synonym(dataset_id, synonym_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/synonym"
    unless synonym_id.nil?
      endpoint = "#{endpoint}/#{synonym_id}"
    end
    if subresource == 'source'
      endpoint = "#{endpoint}/source"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
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
  # @param taxon_id [String] The taxon id
  # @param subresource [String] The taxon subresource endpoint (classification, distribution, info, interaction, media,
  #   relation, source, synonyms, treatment, or vernacular)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon(dataset_id, taxon_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/taxon"
    unless taxon_id.nil?
      endpoint = "#{endpoint}/#{taxon_id}"
    end

    subresources = %w[classification distribution info interaction media relation source synonyms treatment vernacular]
    if !subresource.nil? and subresources.include? subresource
      endpoint = "#{endpoint}/#{subresource}"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
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
  def self.tree(dataset_id, taxon_id: nil, children: false, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/tree"
    endpoint = "#{endpoint}/#{taxon_id}" unless taxon_id.nil?
    endpoint = "#{endpoint}/children" unless taxon_id.nil? or !children
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

end
