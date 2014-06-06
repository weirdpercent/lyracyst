class Spinach::Features::Info < Spinach::FeatureSteps
  step 'I run `lyracyst rb inf fuck`' do
    @output = `lyracyst rb inf fuck`
  end

  step 'the output should contain word info' do
    @output =~ /\[Word info\] - [A-Za-z0-9: |ˈfʌk\.]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
