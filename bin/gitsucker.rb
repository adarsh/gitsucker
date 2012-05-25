#!/usr/bin/env ruby

require File.expand_path('../../lib/gitsucker', __FILE__)

ARGV.each do |repo_name|
  table = Gitsucker::Table.new(repo_name)
  table.output_results
end
