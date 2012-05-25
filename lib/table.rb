class Table
  def initialize(input)
    @input = input
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
    Repo.new(@input).forking_authors.each do |author|
      puts column_spacing % author.stats
    end
  end

  def display_header
    puts column_spacing % Author::STAT_TYPES
    puts '='*80
  end
end

