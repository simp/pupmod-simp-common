require 'spec_helper_acceptance'

test_name 'common class'

describe 'common class' do
  let(:manifest) {
    <<-EOS
      class { 'common': }
    EOS
  }

  hosts.each do |host|
    context 'default parameters' do
      # Using puppet_apply as a helper
      it 'should work with no errors' do
        apply_manifest_on(host, manifest, :catch_failures => true)
      end
    end
  end
end
