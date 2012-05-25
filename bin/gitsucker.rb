#!/usr/bin/env ruby

require_relative File.expand_path('../lib/gitsucker', __FILE__)

ARGV.each do |repo_name|
  table = Table.new(repo_name)
  table.output_results
end
