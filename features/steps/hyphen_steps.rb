class Spinach::Features::Hyphenation < Spinach::FeatureSteps
  step 'I run `lyracyst wn hyph communication`' do
    @output = `lyracyst wn hyph communication`
  end

  step 'the output should contain a hyphenation' do
    @output =~ /\[Hyphenation\] - [a-z-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
