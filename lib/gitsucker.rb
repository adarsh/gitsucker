require 'open-uri'
require 'json'
require 'nokogiri'

require_path = File.dirname(File.expand_path(__FILE__))

%w(author repo table repo_author_list).each do |file|
  require require_path + "/gitsucker/#{file}"
end

ORIGINAL_REPO_VALUE = 3
RUBY_REPO_VALUE = 2
JS_REPO_VALUE = 2
FORKED_REPO_VALUE = 1
