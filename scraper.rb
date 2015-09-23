#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'colorize'
require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.css('figure').each do |figure|
    data = { 
      name: figure.text.tidy,
      image: figure.css('a/@href').text,
      email: figure.xpath('following::strong[1]/following::text()').text.tidy.split(/\s/).find { |t| t.include? '@' },
    }
    ScraperWiki.save_sqlite([:name, :image], data)
  end
end

scrape_list('http://www.sainthelena.gov.sh/your-council/')
