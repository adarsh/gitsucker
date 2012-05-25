require 'spec_helper'

describe Gitsucker::Author, '#name' do
  it 'is exposed' do
    Gitsucker::Author.new('name').name.should == 'name'
  end
end

describe Gitsucker::Author, 'STAT_TYPES' do
  it 'has correct values' do
    Gitsucker::Author::STAT_TYPES.should == %w(name all originals forked ruby js score)
  end
end

%w(original_repo_count forked_repo_count js_repo_count ruby_repo_count).each do |method_name|
  describe Gitsucker::Author, "##{method_name}" do
    it 'delegates to the github profile' do
      author = Gitsucker::Author.new('name')
      author.should delegate(method_name).to(:github_profile)
    end
  end
end
