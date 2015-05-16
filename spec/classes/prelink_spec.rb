require 'spec_helper'

describe 'common::prelink' do

  it { should compile.with_all_deps }
  it { should contain_file('/etc/sysconfig/prelink').with_content(/PRELINKING=no/) }

end
