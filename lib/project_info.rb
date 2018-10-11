# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def news_api_country(country)
  'https://newsapi.org/v2/top-headlines?country=' + country
end

def call_news_url(config, url)
  HTTP.headers(
    'Authorization' => "token #{config['NEWS_TOKEN']}"
  ).get(url)
end

news_response = {}
news_results = {}

## happy requests
project_url = news_api_country('tw')
news_response[project_url] = call_news_url(config, project_url)
project = news_response[project_url].parse

news_results['status'] = project['status']
#should be ok

news_results['totalResults'] = project['totalResults']
#should be 20


## bad request
bad_project_url = news_api_country('apple')
news_response[bad_project_url] = call_news_url(config, bad_project_url)
news_response[bad_project_url].parse

File.write('spec/fixtures/news_response.yml', news_response.to_yaml)
File.write('spec/fixtures/news_results.yml', news_results.to_yaml)