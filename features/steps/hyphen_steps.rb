class Spinach::Features::Hyphenation < Spinach::FeatureSteps
  step 'I run `lyracyst hyphen communication`' do
    @output = `lyracyst hyphen communication`
  end

  step 'the output should contain a hyphenation' do
    @output =~ /\[Hyphenation\] - [a-z-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
