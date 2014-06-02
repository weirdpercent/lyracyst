class Spinach::Features::Initconfig < Spinach::FeatureSteps
  step 'I run `lyracyst -h net_http_persistent -j oj -x rexml initconfig --force`' do
    @output = `lyracyst -h net_http_persistent -j oj -x rexml initconfig --force`
  end

  step 'the output should contain a confirmation' do
    @output =~ /Configuration file [A-Za-z '\/.]* written./
  end

  step 'the configuration file should exist' do
    File.exist?('~/.lyracyst.yml')
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
