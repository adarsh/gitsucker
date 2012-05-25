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
