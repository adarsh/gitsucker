require 'spec_helper'

describe 'Gitsucker constants' do
  it 'values original repos correctly' do
    ORIGINAL_REPO_VALUE.should == 3
  end

  it 'values ruby repos correctly' do
    RUBY_REPO_VALUE.should == 2
  end

  it 'values JS repos correctly' do
    JS_REPO_VALUE.should == 2
  end

  it 'values forked repos correctly' do
    FORKED_REPO_VALUE.should == 1
  end
end
