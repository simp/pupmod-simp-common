# == Class: common::sudoers
#
# This class provides some useful aliases that many people have wanted
# to use over time.
#
# None of this is mandatory and all can be changed via the different
# parameters.
#
# Each section simply adds the entry to the sudoers file by joining
# the array together appropriately.
#
# == Authors
#
#  * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class common::sudoers (
  $audit_alias      = [
    '/bin/cat',
    '/bin/ls',
    '/usr/bin/lsattr',
    '/sbin/aureport',
    '/sbin/ausearch',
    '/sbin/lspci',
    '/sbin/lsusb',
    '/sbin/lsmod',
    '/usr/sbin/lsof',
    '/bin/netstat',
    '/sbin/ifconfig -a',
    '/sbin/route ""',
    '/sbin/route -[venC]',
    '/usr/bin/getent',
    '/usr/bin/tail'
  ],
  $delegating_alias = [
    '/usr/sbin/visudo',
    '/bin/chown',
    '/bin/chmod',
    '/bin/chgrp'
  ],
  $drivers_alias = [
    '/sbin/modprobe'
  ],
  $locate_alias = [
    '/usr/sbin/updatedb'
  ],
  $networking_alias = [
    '/sbin/route',
    '/sbin/ifconfig',
    '/bin/ping',
    '/sbin/dhclient',
    '/usr/bin/net',
    '/sbin/iptables',
    '/usr/bin/rfcomm',
    '/usr/bin/wvdial',
    '/sbin/iwconfig',
    '/sbin/mii-tool'
  ],
  $processes_alias = [
    '/bin/nice',
    '/bin/kill',
    '/usr/bin/kill',
    '/usr/bin/killall'
  ],
  $services_alias = [
    '/sbin/service',
    '/sbin/chkconfig'
  ],
  $selinux_alias = [
    '/sbin/restorecon',
    '/usr/bin/audit2why',
    '/usr/bin/audit2allow',
    '/usr/sbin/getenforce',
    '/usr/sbin/setenforce',
    '/usr/sbin/setsebool'
  ],
  $software_alias = [
    '/bin/rpm',
    '/usr/bin/up2date',
    '/usr/bin/yum'
  ],
  $storage_alias = [
    '/sbin/fdisk',
    '/sbin/sfdisk',
    '/sbin/parted',
    '/sbin/partprobe',
    '/bin/mount',
    '/bin/umount'
  ],
  $su_alias      = [ '/bin/su' ],
  $default_entry = [
    'listpw=all',
    'requiretty',
    'syslog=authpriv',
    '!root_sudo',
    '!umask',
    'env_reset',
    'secure_path = /usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    'env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR \
      LS_COLORS MAIL PS1 PS2 QTDIR USERNAME \
      LANG LC_ADDRESS LC_CTYPE LC_COLLATE LC_IDENTIFICATION \
      LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC \
      LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS \
      _XKB_CHARSET XAUTHORITY"'
  ]
) {

    include 'sudo'

    sudo::alias::cmnd { 'audit':
        comment => 'System Audit Related Commands',
        content => $audit_alias
    }

    sudo::alias::cmnd { 'delegating':
        comment => 'Delegating System Permissions',
        content => $delegating_alias
    }

    sudo::alias::cmnd { 'drivers':
        comment => 'Driver Manipulation',
        content => $drivers_alias
    }

    sudo::alias::cmnd { 'locate':
        comment => 'Updating Slocate',
        content => $locate_alias
    }

    sudo::alias::cmnd { 'networking':
        comment => 'Useful Networking Commands',
        content => $networking_alias
    }

    sudo::alias::cmnd { 'processes':
        comment => 'Process Manipulation',
        content => $processes_alias
    }

    sudo::alias::cmnd { 'services':
        comment => 'Service Management',
        content => $services_alias
    }

    sudo::alias::cmnd { 'selinux':
        comment => 'SELinux Management and Troubleshooting',
        content => $selinux_alias
    }

    sudo::alias::cmnd { 'software':
        comment => 'Installation and Management of Software',
        content => $software_alias
    }

    sudo::alias::cmnd { 'storage':
        comment => 'Storage Related Commands',
        content => $storage_alias
    }

    sudo::alias::cmnd { 'su':
        content => $su_alias
    }

    sudo::default_entry { '00_main':
        content => $default_entry
    }
}
