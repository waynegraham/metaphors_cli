#!/usr/bin/env ruby

require 'rubygems'
require 'rsolr'
require 'rsolr-ext'

TARGET = 'http://sds3.itc.virginia.edu:8080/metaphors_solr/'
TABLE_BORDER = "+" + "-" * 27 + "+"

# Query syntax http://lucene.apache.org/java/2_4_0/queryparsersyntax.html

$solr = RSolr::Ext.connect :url => TARGET

def generate_report(term)

  (1600..1800).step(10).each do |year|
    response = query_solr(term, year)

    puts TABLE_BORDER
    puts print_header(term,year)
    puts TABLE_BORDER
    puts print_rows(response)
    puts TABLE_BORDER
  end
end

def print_rows(response)
  result = ""
  response.facets.each do |facet|
    facet.items.each do |item|
      result += "|" + sprintf("%20s", item.value) + "|" + sprintf("%6d", item.hits) + "|\n" if item.hits > 0
    end
  end if response.ok?
  result
end

def print_header(term, year)
  "|" + sprintf("%20s", term) + "|" + sprintf("%6s", "#{year}") + "|"
end

def query_solr(term, year)

  work_year = year.to_s.chop! + "*"
  solr_params = {
    :queries => { :categories => term, :work_year => work_year },
    :facets => { :fields => ['work_genres'] }
  }

  $solr.find solr_params

end

terms = %w(Fetters Architecture)

terms.each do |term|
  puts generate_report(term)
end



