#! /usr/bin/env ruby

require 'rubygems'
require 'rsolr'
require 'rsolr-ext'
require 'thor'
require 'csv'
require 'colorize'

class SolrUtilities
  SOLR_SERVER = 'http://sdsv3.its.virginia.edu:8080/metaphors_solr/'
  REPORT_FIELDS = %w(Drama Poetry Fiction Prose)

  $solr = RSolr::Ext.connect :url => SOLR_SERVER

  def initialize(term)
    @term = term
  end

  def query_solr(year)
    year_string = "{#{year} TO #{year + 9}}"

    solr_params = {
      :queries => { :categories => @term, :work_year_sort => year_string },
      :facets => { :fields => ['work_genres'] }
    }

    $solr.find solr_params
  end

  def print_header
    (1690..1800).step(10) { |n| print "\t#{n}" }
  end

  def generate_report
    print_header

    REPORT_FIELDS.each do |field|
      print "\n#{build_counts(field)}"
    end
  end

  def build_counts(field)
    report_string = field

    (1690..1800).step(10).each do |year|
      response = query_solr(year)

      response.facets.each do |facet|
        facet.items.each do |item|
          if item.value == field
            report_string += "\t" + item.hits.to_s
          end
        end
      end if response.ok?
    end

    report_string
  end

end

class MetaphorsCLI < Thor

  class_option :verbose, :type => :boolean

  desc "search LIST", "search the Metaphors index for a list of options"
  def search(term)

    utils = SolrUtilities.new(term)

    puts "\nGenerating Report for \"#{term}\"...\n".green if options[:verbose]

    utils.generate_report

    puts "\n\n Report Finished".green if options[:verbose]

  end

end

MetaphorsCLI.start(ARGV)
