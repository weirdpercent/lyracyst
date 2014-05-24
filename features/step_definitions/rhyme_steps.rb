Then(/^the output should contain rhymes$/) do
  @output = `lyracyst rhyme orange`
  @output =~ /\[Rhymes\] - [a-z|]*/
  $?.exitstatus == 0
end
