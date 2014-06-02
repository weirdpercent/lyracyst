class Spinach::Features::Pronounce < Spinach::FeatureSteps
  step 'I run `lyracyst pronounce beautiful`' do
    @output = `lyracyst pronounce beautiful`
  end

  step 'the output should contain a pronunciation' do
    @output =~ /\[Pronunciation\] - [A-Za-z0-9 |\(\)͞oˈtə\-fəlū"tĭ*fụl͞]*/
  end

  step 'the exit status should be 0' do
    $?.exitstatus == 0
  end
end
