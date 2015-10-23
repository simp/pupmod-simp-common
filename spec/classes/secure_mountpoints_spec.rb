require 'spec_helper'

describe 'common::secure_mountpoints' do
  base_facts = {
    :operatingsystem => 'CentOS',
    :operatingsystemmajrelease => '6',
    :operatingsystemrelease => '6.5',
    :ipaddress => '10.10.10.10',
    :fqdn => 'foo.bar.baz',
    :hostname => 'foo',
    :interfaces => 'eth0',
    :ipaddress_eth0 => '10.10.10.10',
    :selinux_current_mode => 'enforcing'
  }

  let(:facts){base_facts}

  it {
    should compile.with_all_deps
  }
  it { should contain_mount('/dev/pts').with_options('rw,gid=5,mode=620,noexec') }
  it { should contain_mount('/sys').with_options('rw,nodev,noexec') }
  it { should contain_mount('/tmp').with({
    :options => 'bind,defcontext=system_u:object_r:tmp_t:s0,nodev,noexec,nosuid',
    :device  => '/tmp'
  })}
  it { should contain_mount('/var/tmp').with({
    :options => 'bind,defcontext=system_u:object_r:tmp_t:s0,nodev,noexec,nosuid',
    :device  => '/tmp'
  })}

  context 'tmp_is_partition' do
    new_facts = base_facts.dup
    new_facts[:tmp_mount_tmp] = 'rw,seclabel,relatime,data=ordered'
    new_facts[:tmp_mount_fstype_tmp] = 'ext4'
    new_facts[:tmp_mount_path_tmp] = '/dev/sda3'

    let(:facts){new_facts}

    it { should contain_mount('/tmp').with({
      :options => "#{new_facts[:tmp_mount_tmp]},noexec,nosuid,nodev".split(',').sort.join(','),
      :device  => '/dev/sda3'
    })}
  end

  context 'tmp_is_already_bind_mounted' do
    new_facts = base_facts.dup
    new_facts[:tmp_mount_tmp] = 'bind,foo'
    new_facts[:tmp_mount_fstype_tmp] = 'ext4'
    new_facts[:tmp_mount_path_tmp] = '/tmp'

    let(:facts){new_facts}

    it { should contain_mount('/tmp').with({
      :options => "bind,defcontext=system_u:object_r:tmp_t:s0,nodev,noexec,nosuid",
      :device  => '/tmp'
    })}
  end

  context 'var_tmp_is_partition' do
    new_facts = base_facts.dup
    new_facts[:tmp_mount_var_tmp] = 'rw,seclabel,relatime,data=ordered'
    new_facts[:tmp_mount_fstype_var_tmp] = 'ext4'
    new_facts[:tmp_mount_path_var_tmp] = '/dev/sda3'

    let(:facts){new_facts}

    it { should contain_mount('/var/tmp').with({
      :options => "#{new_facts[:tmp_mount_var_tmp]},noexec,nosuid,nodev".split(',').sort.join(','),
      :device  => '/dev/sda3'
    })}
  end

  context 'var_tmp_is_already_bind_mounted' do
    new_facts = base_facts.dup
    new_facts[:tmp_mount_var_tmp] = 'bind,foo'
    new_facts[:tmp_mount_fstype_var_tmp] = 'ext4'
    new_facts[:tmp_mount_path_var_tmp] = '/var/tmp'

    let(:facts){new_facts}

    it { should contain_mount('/var/tmp').with({
      :options => "bind,defcontext=system_u:object_r:tmp_t:s0,nodev,noexec,nosuid",
      :device  => new_facts[:tmp_mount_path_var_tmp]
    })}
  end

  context 'tmp_mount_dev_shm_mounted' do
    new_facts = base_facts.dup
    new_facts[:tmp_mount_dev_shm] = 'rw,seclabel,nosuid,nodev'
    new_facts[:tmp_mount_fstype_dev_shm] = 'tmpfs'
    new_facts[:tmp_mount_path_dev_shm] = 'tmpfs'

    let(:facts){new_facts}

    it { should contain_mount('/dev/shm').with({
      :options => 'nodev,noexec,nosuid,rw,seclabel',
      :device  => new_facts[:tmp_mount_path_dev_shm]
    })}
  end
end
