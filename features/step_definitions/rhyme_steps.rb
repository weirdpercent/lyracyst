Then(/^the output should contain rhymes$/) do
  @output = `lyracyst rbrain rhyme orange`
  @output =~ /\[Rhymes\] - [a-z|]*/
  $?.exitstatus == 0
end
