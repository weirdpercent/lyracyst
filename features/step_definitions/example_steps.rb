Then(/^the output should contain an example$/) do
  @output = `lyracyst example test`
  @output =~ /\[Example\]  - [A-Za-z0-9 ,:\-\='"+;\(\)\/\\.?&#]*/
  $?.exitstatus == 0
end
