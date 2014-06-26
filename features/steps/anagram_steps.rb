class Spinach::Features::Anagram < Spinach::FeatureSteps
  step 'I run `lyracyst ana warrenpicketcalender`' do
    @output = `lyracyst ana warrenpicketcalender`
  end

  step 'the output should contain anagrams' do
    @output =~ /[\[\]A-Za-z0-9. :|]/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
