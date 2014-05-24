Then(/^the output should contain a confirmation$/) do
  @output = `lyracyst -h net_http_persistent -j json_pure -x rexml initconfig --force`
  @output =~ /Configuration file [A-Za-z '\/.]* written./
  $?.exitstatus == 0
end
