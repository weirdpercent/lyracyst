class Spinach::Features::Relate < Spinach::FeatureSteps
  step 'I run `lyracyst wn rel test`' do
    @output = `lyracyst wn rel test`
  end

  step 'the output should contain related words' do
    @output =~ /\[Related words\] [A-Za-z0-9 \-,'|ö]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
