require 'spec_helper'

require 'stringio'
describe Gitsucker::Table, '#output_results' do
  it 'displays a header' do
    io = StringIO.new
    Gitsucker::Table.new('my-repo', io).output_results
    expected_regexp = Regexp.new(Gitsucker::Author::STAT_TYPES.join('\s+'))
    io.string.split("\n").first.should =~ expected_regexp
  end

  it 'displays a line below the header' do
    io = StringIO.new
    Gitsucker::Table.new('my-repo', io).output_results
    line = '='*80
    io.string.split("\n")[1].should == line
  end

  it 'displays author stats' do
    authors = [stub('author one',
                    :name => 'one',
                    :public_repo_count => 6,
                    :original_repo_count => 5,
                    :forked_repo_count => 4,
                    :ruby_repo_count => 3,
                    :js_repo_count => 2,
                    :score => 1),
                stub('author two',
                    :name => 'two',
                    :public_repo_count => 1,
                    :original_repo_count => 2,
                    :forked_repo_count => 3,
                    :ruby_repo_count => 4,
                    :js_repo_count => 5,
                    :score => 6)]
    repo = stub('repo', :forking_authors => authors)
    Gitsucker::Repo.stubs(:new => repo)
    io = StringIO.new
    Gitsucker::Table.new('my-repo', io).output_results

    authors.each do |author|
      expected_regexp = Regexp.new([
        author.name,
        author.public_repo_count,
        author.original_repo_count,
        author.forked_repo_count,
        author.ruby_repo_count,
        author.js_repo_count,
        author.score].join('\s+'))
      io.string.should =~ expected_regexp
    end
  end
end
