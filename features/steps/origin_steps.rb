class Spinach::Features::Origin < Spinach::FeatureSteps
  step 'I run `lyracyst wn ori test`' do
    @output = `lyracyst wn ori test`
  end

  step 'the output should contain an etymology' do
    @output =~ /\[Etymology\] - [A-Za-z0-9\[\]. ,;\(\)-|√™t†t√™e]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
