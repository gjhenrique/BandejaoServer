# frozen_string_literal: true

require 'net/http'
require 'open-uri'
require 'nokogiri'

module Parser
  module Fetcher
    attr_reader :resource

    def fetch_html(url, options = {})
      options[:encoding] ||= 'UTF-8'
      @resource = Nokogiri::HTML(open(url), nil, options[:encoding])
    end

    def fetch_json(url)
      response = Net::HTTP.post_form(URI.parse(url), {})
      @resource = response.body
      return nil if response.body.empty?

      JSON.parse response.body
    end
  end
end
