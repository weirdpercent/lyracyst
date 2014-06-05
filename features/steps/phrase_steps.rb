class Spinach::Features::Phrase < Spinach::FeatureSteps
  step 'I run `lyracyst wordnik phrase test`' do
    @output = `lyracyst wordnik phrase test`
  end

  step 'the output should contain a phrase' do
    @output =~ /\[Bi-gram phrases\] - [a-z |']*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
