require 'open-uri'
require 'json'
require 'nokogiri'

require_path = File.dirname(File.expand_path(__FILE__))

%w(author repo table repo_author_list scorer).each do |file|
  require require_path + "/gitsucker/#{file}"
end

module Gitsucker
end
