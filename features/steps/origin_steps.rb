class Spinach::Features::Origin < Spinach::FeatureSteps
  step 'I run `lyracyst origin test`' do
    @output = `lyracyst origin test`
  end

  step 'the output should contain an etymology' do
    @output =~ /\[Etymology\] - [A-Za-z0-9\[\]. ,;\(\)-|√™t†t√™e]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
