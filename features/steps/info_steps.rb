class Spinach::Features::Info < Spinach::FeatureSteps
  step 'I run `lyracyst rbrain info fuck`' do
    @output = `lyracyst rbrain info fuck`
  end

  step 'the output should contain word information' do
    @output =~ /\[Word info\] - [A-Za-z0-9: |ˈfʌk\.]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
