#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# Process the data from each source before comparison
class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [->(val) { val.gsub(/ Constituency$/, '').upcase }] }
  end

  def external_csv_options
    # remove anything in brackets (usually Party shortnames)
    { converters: [->(val) { val.gsub(/ \(.*?\)/, '').gsub(/ Constituency$/, '').upcase }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r.last.to_s] }.reverse.map(&:to_csv)
