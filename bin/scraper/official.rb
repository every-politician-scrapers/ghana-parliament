#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :id do
      noko.css('a/@href').text[/mp=(\d+)/, 1]
    end

    field :name do
      noko.css('b.padd').text.tidy
    end

    field :party do
      noko.xpath('.//hr/preceding-sibling::p').text.tidy
    end

    field :constituency do
      noko.xpath('.//hr/following-sibling::b').text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      members_list.map { |mp| fragment(mp => Member).to_h }
    end

    private

    def members_list
      noko.css('.mpcard')
    end
  end
end

urls = ('A'..'Z').map do |letter|
  "https://www.parliament.gh/mps?az&filter=#{letter}"
end

# Override the default data to sort the final list
#  (this can't be done in :members above, as that would only sort one
#  page at a time)
class SortedData < EveryPoliticianScraper::ScraperData
  def data
    super.sort_by { |h| h[:id].to_s.to_i }
  end
end

puts SortedData.new(urls).csv
