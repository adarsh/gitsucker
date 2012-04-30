class Table
  def initialize(input)
    @input = input
  end

  def output_results
    display_header

    begin
      Repo.new(@input).get_forking_authors.each do |author|
        puts column_spacing % author.stats
      end
    rescue
      puts 'Repo not found.'
    end
  end

  private

  def column_spacing
    '%-20s %-10s %-10s %-10s %-10s %-10s %-10s'
  end

  def display_header
    puts column_spacing % Author.stat_types
    print '='*80
    puts
  end
end

