# Class: common::localusers
#
# This class provides the ability to provide local users (or any other type of
# user) to all of your clients.
#
# This is only needed if the native Puppet type cannot manage passwords on your
# systems.
# ---
#
# == Parameters ==
#
# [*source*]
# Type: Absolute Path
#
class common::localusers (
  $source = "${::settings::environmentpath}/${::environment}/localusers"
) {
  include 'common'

  $localusers = localuser($source,$::fqdn)

  exec { 'modify_local_users':
    command     => '/usr/local/sbin/simp/localusers.rb',
    path        => '/bin:/usr/sbin',
    refreshonly => true,
    tag         => 'firstrun'
  }

  file { '/usr/local/sbin/simp/localusers.rb':
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('common/localusers.rb.erb'),
    tag     => 'firstrun',
    notify  => Exec['modify_local_users']
  }

  validate_array($localusers)
  validate_absolute_path($source)
}
