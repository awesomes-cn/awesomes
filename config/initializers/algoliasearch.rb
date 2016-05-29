require 'algoliasearch'
AlgoliaSearch.configuration = { application_id: ENV['SEARCH_PID'], api_key: ENV['SEARCH_KEY']}