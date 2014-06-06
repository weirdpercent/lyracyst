class Spinach::Features::Define < Spinach::FeatureSteps
  step 'I run `lyracyst wn def test`' do
    @output = `lyracyst wn def test`
  end

  step 'the output should contain definitions' do
    @output =~ /\[Definition\] [a-z-]* - [A-Za-z0-9 ,;:'"\.\(\)”-]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
