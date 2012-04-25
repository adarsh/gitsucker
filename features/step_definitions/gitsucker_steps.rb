Given /^I have a github repo called "([^']*)"$/ do |repo|
  @repo_query = repo
end

When /^I enter the github repo name$/ do
  @output = `ruby gitsucker.rb #{@repo_query}`
  raise('Command failed') unless $?.success?
end

Then /^I should get the following attributes:$/ do |table|
  expected_output = []
  table.hashes.each do |attributes|
    expected_output << attributes
  end

  @output.chomp.should == expected_output
end
