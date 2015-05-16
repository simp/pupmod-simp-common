require 'spec_helper'

describe 'common::modprobe_blacklist' do
  let(:facts){{
    :operatingsystem => 'CentOS',
    :lsbdistrelease => '6.5',
    :lsbmajdistrelease => '6'
  }}

  it { should compile.with_all_deps }

  context 'disable' do
    let(:params){{ :enable => false }}
    it { should create_file('/etc/modprobe.d/00_simp_blacklist.conf').with_ensure('absent') }
  end

end
