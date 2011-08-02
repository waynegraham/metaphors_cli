#!/usr/bin/env ruby

require 'rubygems'
require 'rsolr'
require 'rsolr-ext'

TARGET = 'http://sds3.itc.virginia.edu:8080/metaphors_solr/'
TABLE_BORDER = "+" + "-" * 78 + "+"

# Query syntax http://lucene.apache.org/java/2_4_0/queryparsersyntax.html


solr = RSolr::Ext.connect :url => TARGET

solr_params = {
  :queries => {:categories => 'Fetters', :work_year => '171*'},
  :facets => {:fields => ['work_genres']}
}

response = solr.find solr_params

puts response.params

puts TABLE_BORDER

puts "|" + sprintf("%20s", "") + "|" + sprintf("%6s", "1710") + "|"

puts TABLE_BORDER
response.facets.each do |facet|
  facet.items.each do |item|
    puts "|" + sprintf("%20s", item.value) + "|" + sprintf("%6d", item.hits) + "|" if item.hits > 0
  end
end if response.ok?

puts TABLE_BORDER


