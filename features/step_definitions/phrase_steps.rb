Then(/^the output should contain a phrase$/) do
  @output = `lyracyst phrase test`
  @output =~ /\[Bi-gram phrases\] - [a-z |']*/
  $?.exitstatus == 0
end
