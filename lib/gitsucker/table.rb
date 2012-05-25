module Gitsucker
  class Table
    def initialize(repo_name, output = STDOUT)
      @repo_name = repo_name
      @output = output
    end

    def output_results
      display_header

      begin
        display_author_stats
      rescue
        puts 'Repo not found.'
      end
    end

    private

    def column_spacing
      '%-20s %-10s %-10s %-10s %-10s %-10s %-10s'
    end

    def display_author_stats
      Repo.new(@repo_name).forking_authors.each do |author|
        @output.printf column_spacing,
          author.name,
          author.public_repo_count,
          author.original_repo_count,
          author.forked_repo_count,
          author.ruby_repo_count,
          author.js_repo_count,
          author.score
        @output.puts
      end
    end

    def display_header
      @output.puts column_spacing % Author::STAT_TYPES
      @output.puts '='*80
    end
  end
end
