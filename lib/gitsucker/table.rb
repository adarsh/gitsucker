module Gitsucker
  class Table
    def initialize(repo_name)
      @repo_name = repo_name
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
        printf column_spacing,
          author.name,
          author.public_repo_count,
          author.original_repo_count,
          author.forked_repo_count,
          author.ruby_repo_count,
          author.js_repo_count,
          author.score
        puts
      end
    end

    def display_header
      puts column_spacing % Author::STAT_TYPES
      puts '='*80
    end
  end
end
