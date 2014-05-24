class Spinach::Features::Combine < Spinach::FeatureSteps
  step 'I run `lyracyst combine test`' do
    @output = `lyracyst combine test`
  end

  step 'the output should contain a portmanteau' do
    @output =~ /\[Portmanteaus\] - [A-Za-z0-9:.,'| ]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end