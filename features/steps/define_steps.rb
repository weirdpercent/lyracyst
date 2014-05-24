class Spinach::Features::Define < Spinach::FeatureSteps
  step 'I run `lyracyst define test`' do
    @output = `lyracyst define test`
  end

  step 'the output should contain a definition' do
    @output =~ /\[Definition\] [a-z-]* - [A-Za-z0-9 ,;:'"\.\(\)”-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
