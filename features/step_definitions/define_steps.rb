Then(/^the output should contain a definition$/) do
  @output = `lyracyst wordnik define test`
  @output =~ /\[Definition\] [a-z-]* - [A-Za-z0-9 ,;:'"\.\(\)”-]*/
  $?.exitstatus == 0
end
