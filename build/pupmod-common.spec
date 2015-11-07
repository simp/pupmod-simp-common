Summary: Common Puppet Module
Name: pupmod-common
Version: 4.2.0
Release: 23
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: pupmod-augeasproviders_grub
Requires: pupmod-augeasproviders_sysctl
Requires: pupmod-onyxpoint-gpasswd
Requires: puppetlabs-stdlib
Requires: pupmod-simpcat >= 2.0.0-0
Requires: pupmod-functions >= 2.0.0-0
Requires: pupmod-named >= 4.2.0-2
Requires: pupmod-rsync >= 2.0.0-0
Requires: pupmod-site >= 2.0.0-0
Requires: pupmod-sssd >= 2.0.0-0
Requires: pupmod-stunnel >= 4.1.0-2
Requires: pupmod-sysctl >= 4.1.0-2
Requires: puppet >= 3.4
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Requires: simp-simplib >= 1.0.0
Obsoletes: pupmod-timezone
Obsoletes: pupmod-sec
Obsoletes: pupmod-elinks
Obsoletes: pupmod-grub
Obsoletes: pupmod-common-test

Prefix: /etc/puppet/environments/simp/modules

%description
This Puppet module provides a set of common classes for your system including:
 * Useful base applications
 * Inittab management
 * Nsswitch management
 * Resolv.conf management
 * /etc/sysconfig management
 * /etc defaults
 * Initlog management
 * /etc/host.conf management
 * /etc/libuser.conf management
 * Dynamic swappiness

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/common

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/common
done

# Make Puppet stop complaining about not having facts.d
mkdir -p %{buildroot}%{prefix}/common/facts.d

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/common

%files
%defattr(0640,root,puppet,0750)
%{prefix}/common

%post
#!/bin/sh

if [ -d %{prefix}/common/plugins ]; then
  /bin/mv %{prefix}/common/plugins %{prefix}/common/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Sat Nov 07 2015 Chris Tessmer <chris.tessmer@onyxpoint.com> - 4.2.0-23
- Moved functions out of common and into simplib
- Changed concat dependency to simpcat

* Tue Oct 27 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-22
- Fixed the tmp mountpoint code
  - Stopped managing the default SELinux context
  - Fixed the default facts to properly return the mount options on the temp partitions
  - Users with bind mounted /tmp directories will need to unmount them and
    remove them from /etc/fstab prior to being able to fully work around the
    bug.
- Updates based on testing FIPS mode
  - The system can now disable FIPS via Puppet properly
  - The 'fips_enabled' fact now works properly on EL6

* Tue Sep 22 2015 Kendall Moore <kmoore@keywcorp.com> - 4.2.0-21
- Only create a reboot notification for FIPS is fips is actually being
  enabled/disabled.

* Thu Jul 09 2015 Nick Markowski <nmarkowski@keywcorp.com> - 4.2.0-20
- Do not attempt to rsync crontab or anacrontab by default; we no
  longer supply them in rsync global_etc.
- Added a function to parse host strings/urls.  Returns a hash of
  hostnames with an array of ports and an array of protocols.
  Modified strip_ports to use parse_hosts and added get_ports to
  return stripped ports.
- Removed dynamic_swappiness cron job if a static value is set for swappiness.

* Fri May 01 2015 Kendall Moore <kmoore@keywcorp.com> - 4.2.0-19
- Ensure <puppet_vardir>/simp directory gets created.

* Tue Apr 28 2015 Nick Markowski <nmarkowski@keywcorp.com> - 4.2.0-18
- Ensured the keygen space was puppet writeable.

* Thu Apr 09 2015 Trevor Vaughan <tvaughan@onyxpoint.com>  - 4.2.0-17
- passgen() now has the ability to select a complexity level and also has
  vastly improved error handling capabilities
- Now have the ability to only return remote IP addresses from the
  ipaddresses() function.

* Mon Mar 30 2015 Chris Tessmer <chris.tessmer@onyxpoint.com> - 4.2.0-17
- Check for $?.nil? in ipv6_enabled fact

* Thu Mar 12 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-16
- Actually change *all* of the rp_filter settings appropriately.

* Fri Feb 27 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-15
- Allow the sysctl value for rp_filter to be set to 2.

* Thu Feb 19 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-14
- Migrated to the new 'simp' environment.

* Mon Dec 15 2014 Kendall Moore <kmoore@keywcorp.com> - 4.2.0-13
- Updated all custom functions to properly scope internal defines.

* Sat Dec 06 2014 Chris Tessmer <chris.tessmer@onyxpoint.com - 4.2.0-13
- backported host_is_me() fixes from 4.0.X

* Tue Nov 25 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-12
- Added a function rand_cron that allows any string or integer to be
  used to return a value off cron items.
- Updated the validation for kernel__core_pattern to ensure that all
  valid options are allowed.
- Added a function, validate_sysctl_value, that allows for defines to
  be written that will perform custom validation of any given sysctl
  value.
- Fixed arrow alignment whitespace.

* Fri Nov 21 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-12
- Added a function, strip_ports, for properly returning an array of
  hostnames, IPv4, or IPv6 addresses with their ports removed.

* Thu Nov 20 2014 Kendall Moore <kmoore@keywcorp.com> - 4.2.0-12
- Updated login_defs template to ensure all variable get put on new lines.

* Mon Nov 17 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-11
- Identified several issues with the way secure_mountpoints was
  working in relation to SELinux on RHEL7. Refactored the code to
  attempt and alleviate these issues. Also made the mount options
  completely configurable.

* Wed Oct 29 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-10
- Fixed the call to the @repos variable in the yum cron job template so that it
  works properly as an Array.

* Wed Oct 01 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-9
- Updated the create_modules variable to properly join the array to
  prevent Ruby 2 magic.

* Mon Sep 08 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-8
- Added support for hidepid on the proc filesystem. Default is set to
  '2' so that users cannot see other user's processes.
- Update the reboot_notify type to add a default reason if, for some
  reason, the recorded value is empty or nil.
- Ensure that validate_array_member dups the passed arguments after
  casting to an Array so that booleans work properly.
- Updated to use the new sysctl::value define.

* Mon Aug 25 2014 Kendall Moore <kmoore@keywcorp.com> - 4.2.0-8
- Moved shmall fact from libvirt to common.

* Sat Aug 23 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-7
- Removed the broken reboot attempt and replaced it with a
  reboot_notify native type.
- Added a facts.d directory to get newer versions of puppet to stop
  complaining.

* Sat Aug 02 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-7
- Updated to use a function that will properly join various mount options and
  prevent issues with SELinux specific options.

* Tue Jul 29 2014 Adam Yohrling <adam.yohrling@onyxpoint.com> - 4.2.0-6
- Added runlevel custom type with systemctl and telinit providers
  to replace runlevel sub-class
- Removed common::runlevel
- Added default_runlevel variable to common

* Fri Jul 25 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-5
- Fixed ipaddresses to ignore interfaces without IP addresses

* Mon Jul 21 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.2.0-5
- Sec and Elinks now obsoleted.

* Sun Jul 13 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-4
- Added a fact init_systems that will return an *array* of init systems present
  on the system.
- Refactored the FIPS code to use the new common::reboot structure and
  associated notification scheme
- Added fact 'cmdline' which returns a *hash* of the kernel command
  line arguments
- Added fact 'reboot_required' which returns a *hash* of the reasons
  why a system reboot is required as used by the common::reboot define
- Added fact 'grub_version' which provides the version of grub installed on the
  system.
- Added fact 'uid_min' which provides the value of the lowest valid user ID on
  the system.
- Modified the 'common' class to indicate that a reboot is required if
  configured to do so

* Mon Jul 07 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-3
- Fixed a typo with PORTTIME_CHECKS_ENAB
- Updated all spec tests to work with the new named module
- Bumped the version number

* Thu Jun 26 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.2.0-2
- Added a template for enabling/disabling FIPS in GRUB.

* Thu Jun 26 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-2
- Updated to work with named module changes for RHEL7.
- Fixed SELinux check for when selinux_current_mode is not found.
- Updated for compatibility with Ruby 2 and Red Hat 7.
- Now allow the localusers file to exist at a different location.

* Sun Jun 22 2014 Kendall Moore <kmoore@keywcorp.com> - 4.2.0-2
- Removed MD5 file checksums for FIPS compliance.

* Fri Jun 06 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.2.0-1
- No longer include a caching nameserver if 127.0.0.1 is the only
  specified nameserver.

* Thu May 29 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.2.0-1
- cron::add_user triggers pam::access::manage to give cron users access to cron/crond
  in /etc/security/access.conf

* Wed Apr 30 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.2.0-0
- This is a major overhaul of the common module based on the
  elimination of the sec module and the move to Hiera.
- common::initlog has been removed
- common::acpid was moved to its own module
- All common includes should be performed via Hiera (or your own ENC)
- common::pre has been removed
- common::host_conf::conf has been moved to common::host_conf and the
  following changes were made:
  - multi is now 'on' by default
  - spoof is now set to 'warn' by default
  - reorder is now set to 'on' by default
  - trim must now be an array
- Most templates were reorganized into spaces that map directly to
  their OS targets
- The localusers script now has the array injected directly into the
  template.
- common::resolv::nameservers must be an array
- common::inittab was removed and replaced with logic in
  common::runlevel since inittab is no longer really used.
- RHEL 5 logic was removed
- common::nsswitch was rewritten to be more flexible
- common::resolv was cleaned up and the common::resolv::conf define
  was rolled into common::resolv
- Moved the common::swappiness::conf define to common::swappiness
- Moved common::sysconfig::init::conf to common::sysconfig::init
- Moved common::yum::pre into common::yum and added configurability
- Moved the old elinks module into common::base_apps
- Incorporated sec::login_defs and allowed for overriding all
  variables
- Moved sec::chkrootkit into common
- Incorporated /etc/issue management from sec
- Added support for managing prelinking
- Pulled the cron material from sec into common::cron
- Collapsed the sysctl material from sec into common::sysctl
- Added management of /etc/shells
- Moved all 'lib' material from sec into common
- Added common::modprobe_blacklist that blacklists SSG recommended
  kernel modules.
- common::set_ftpusers has been replaced by common::ftpusers
- Added common::profile_settings for managing settings in
  /etc/profile.d. These have been renamed from 'local.*' to 'simp.*'
  so you'll need to remove old '/etc/profile.d/local.*' files manually
  if you don't want them to apply.
- Added management of the root user's core attributes (not password).
- Moved the mountpoint mangling from sec into common as
  common::secure_mountpoints.
- Added a validate_float function.
- Added a function to return all client IP addresses from the client as an
  array.
- Updated simp_file_line to ensure that we were replacing files before we don't
  set the content.
- Modified modprobe_blacklist to be array-based instead of a lot of separate
  calls. This works since all values can be set in hiera now.

* Wed Apr 16 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.1.0-7
- Updated facter value calls to new standard

* Tue Apr 01 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-6
- Moved all references of stunnel::stunnel_add to stunnel::add to use the
  latest stunnel.
- Updated the 'secure_path' entry in common::sudoers.
- Complete overhaul of the common module.
- Incorporated the timezone module directly into common::timezone

* Wed Mar 19 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-6
- Updated nets2cidr and nets2ddq to work around hostnames that are passed as
  part of the argument Array.
- Created a common function PuppetX::SIMP::Common.hostname?.
- It must be loaded directly if using from another function with something like
  require File.expand_path(File.dirname(__FILE__) +
  '/../../../puppetx/simp/common.rb')
- Updated validate_net_list to use the new hostname? function.

* Thu Mar 13 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-5
- Updated several functions to handle Fixnum entries properly since
  Hiera sometimes returns them.
- Added validate_re_array which works the same way as validate_re from
  stdlib except that it can take an input array.

* Thu Mar 06 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-4
- Added validate_macaddress.
- Added validate_port.

* Wed Feb 19 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-3
- Converted all boolean strings to native booleans.
- Updated validate_net_list to ignore hostnames with ports.

* Mon Feb 10 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-3
- Fixed the spacing around the '=' in libuser.conf.erb.

* Tue Jan 28 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-2
- Added the ldap_password option to libuser.conf.
- Migrated the common::libuser_conf::conf singleton define to the
  common::libuser_conf class.
- Moved the atd service into common from sec.
- atd will no longer be managed by the default configuration.
- Converted all boolean strings to native booleans

* Sun Jan 26 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-1
- Updated validate_net_list to properly handle IPv6 addresses.

* Fri Jan 03 2014 Nick Markowski <nmarkowski@keywcorp.com> - 4.1.0-1
- Fixed validate_umask typo, and it now allows 3 OR 4 length arguments

* Tue Nov 12 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-0
- Modified the sysctl calls to ensure that users can modify any
  setting from Hiera.

* Mon Nov 04 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-0
- Added custom function 'validate_between' which checks to see if a
  passed value is between two other values.
- Collapsed all common::sysctl::* items into a common::sysctl class.
- Updated the common::workstation class to take into account the
  audit module change.
- Added a fact for the ACPI capability being present on a system.
- Used the ACPI fact to ensure that the acpid service is not started
  if the ACPI service isn't supported on the system.

* Thu Oct 24 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.0.0-4
- Added a function validate_array_member to validate whether or not a
  passed string or array is completely contained in another array.

* Fri Oct 11 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.0.0-3
- Added a new validation function validate_umask that check to see if
  a umask is properly formatted.
- Added PuppetX::SIMP::Common.human_sort

* Thu Oct 03 2013 Kendall Moore <kmoore@keywcorp.com> - 4.0.0-3
- Updated all erb templates to properly scope variables.

* Wed Oct 02 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.0.0-3
- Use 'versioncmp' for all version comparisons.

* Thu Sep 19 2013 Nick Markowski <nmarkowski@keywcorp.com> - 4.0.0-2
- Added listpw=all to defaults of sudo

* Thu Sep 12 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.0.0-1
- Fixed the call to sudo::default_entry to send logs to authpriv
  instead of auth.
- Added custom function 'deep_merge' for doing deep merges of hashes.
- Added custom function 'inspect' for inspecting variables and printing them to
  the server log for debugging.
- Added custom function 'validate_bool_simp' to add support for true/false
  string validation.
- Added custom function 'validate_integer' to allow for simple integer
  validation.
- Modified validate_net_list to support appeneded ports with a ':'.

* Wed Sep 11 2013 Kendall Moore <kmoore@keywcorp.com> - 4.0.0-1
- Added custom function 'validate_deep_hash'. This takes two hash arguments and
  uses the first to validate the entries in the second.

* Wed Jul 31 2013 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.0.0-0
- Added the custom function 'validate_net_list' which validates that a
  passed array of IP addresses/netmasks is valid. Takes an optional
  regex that allows for specific entries to be ignored.
- Added the custom type simp_file_line which is an enhanced version of the
  Puppet Labs stdlib file_line function.
- Added the options of 'prepend' and 'deconflict' which allow for prepending
  lines and avoiding conflicts with 'file' resources respectively.
- Also ensure that non-avoided conflicts fail with a descriptive error and that
  related files are autorequired since you may be creating them elsewhere.
- The common::resolv class was unhappy with the default case of
  $::named::chroot not being defined (even though that's exactly what we
  wanted) so we now check to see if Class['named'] is defined before calling
  the variable.
- Two utility facts were added:
    - 'array_include':  Determine if an array contains another array OR string.
    - 'array_union':    Return the union of two arrays or array and string.

* Tue Jun 18 2013 Trevor Vaughan <tvaughan@onyxpoint.com> 2.1.2-1
- Updated the resolv.pp file to allow users to select whether or not they wish
  to act as a caching nameserver explicitly. This is fundamentally for
  supporting the use of dnsmasq, or another nameserver that we don't currently
  support.
- Added a variable to resolv.pp allowing users to opt out of having puppet
  automatically configure their system as a SIMP DNS server if the server IP is
  in the passed list of nameservers. This is particularly relevant if you want
  your server to have a different configuration than is activated by default.

* Tue Jan 08 2013 Maintenance
2.1.1-4
- Added the Fedora 16 GPG keys to the list of keys in local.repo since we now
  include packages from the distro by default.
- Added functionality to enable handling more than 15 ports in a single
  multiport rule in the base templates and the optimization code. The
  same technique was used in both places.
- Consolidated the template for TCP and UDP services to reduce code
  repitition.
- The replaced the iptables_running and iptables_saved facts with a
  fact that does a bit more work to determine if we actually need a
  restart.

* Mon Oct 22 2012 Maintenance
2.1.1-3
- Updated the 'inactive' variable in useradd.pp to be 35 instead of
  -1.
- Cleaned up the way ipv6_enabled works to be a bit less error prone.

* Tue Sep 18 2012 Maintenance
2.1.1-2
- Updated all references of /etc/modprobe.conf to /etc/modprobe.d/00_simp_blacklist.conf
  as modprobe.conf is now deprecated.

* Tue Jun 19 2012 Maintenance
2.1.1-1
- Added legacy puppetlabs key to the list of allowed GPG keys.
- Made $::default_runlevel consistent when setting runlevels at the
  global scope.

* Thu Jun 07 2012 Maintenance
2.1.1-0
- Ensure that Arrays in templates are flattened.
- Call facts as instance variables.
- The nightly cron job was malformed an not functioning. This has been
  resolved.
- Added a function 'simp_version' to provide the version of SIMP
  running on the server.
- Made 'ktune' a class at common::ktune so that users can call it if they want
  it and not have to rely on magic under common::sysctl::net. This does mean
  that you must now explicitly call 'common::ktune' if you want to use it.
- Updated to ensure that sysctl calls only present in RHEL5 work properly in
  RHEL6.
- Now use the Puppet Labs stdlib function 'file_line' instead of
  'functions::append_if_no_such_line'
- Added key list to the yum repos.
- Turned on gpgcheck for 'local' and 'simp_updates' yum repos.
- Moved mit-tests to /usr/share/simp...
- Modified the caching DNS server portion to work with IPv6 localhost
  addresses.
- Ensure that, if the caching DNS server is used, /etc/resolv.conf
  only gets altered if the DNS server starts.
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
2.1.0-7
- Updated the passgen function to accept a hash of options allowing for
  the return of a md5, sha256, or sha512 hash with a consistent salt.
- Improved test stubs.

* Wed Feb 15 2012 Maintenance
2.1.0-6
- Added local user modification tests to common to test the localusers utility.
- Removed the parsing of the $puppet_servers variable from
  add_hosts.rb

* Mon Dec 19 2011 Maintenance
2.1.0-5
- Updated the spec file to not require a separate file list.
- Scoped all of the top level variables.
- Changed all instances of 'ipaddress' to 'primary_ipaddress'.
- Patch up resolv.pp to properly include the correct packages when running in
  both RHEL5 and RHEL6 as a caching name server.
- Fix the caching nameserver code which had been drastically broken at some
  point.
- Remove 127.0.0.1 from the list of addresses that are matched in 'host_is_me'.

* Fri Nov 18 2011 Maintenance
2.1.0-4
- Now use the puppet autoloader to load custom functions out of cycle.

* Wed Nov 02 2011 Maintenance
2.1.0-3
- Fixed the issue with 'undefined' showing up in /etc/hosts.
- Forward ported a patch to make resolv.conf handle both arrays and whitespace
  delimited lists.

* Mon Oct 10 2011 Maintenance
2.1.0-2
- Updated to put quotes around everything that need it in a comparison
  statement so that puppet > 2.5 doesn't explode with an undef error.

* Tue Aug 09 2011 Maintenance
2.1.0-1
- localuser.rb now generates SHA512 hashes by default and falls back to MD5 if
  that fails.
- Updated localuser.rb to properly preserve the stated home directory when
  generating a hashed password.
- Updated localuser.rb to properly support the '!' option.
- Updated to make rule files generated for incron have proper newline endings.

* Fri May 27 2011 Maintenance - 2.1.0-0
- You can now delcare a variable '$default_runlevel' before including 'common'
  that will set the default runlevel of the system.
- Added common::resolv::conf which deprecates both common::resolv and
  common::resolv::add_entry.
- Removed common::resolv::add_entry
- Added parameterized class common::resolv which takes the place of common::resolv::conf from 1.3
- Redirected the common::resolv::conf define to call common::resolv for backward compatiblity.

* Mon May 09 2011 Maintenance - 2.0.0-1
- Added some hackery to work around an issue with a function loading another
  function between ip_is_me and host_is_me.
- Changed puppet://$puppet_server/ to puppet:///
- Changes were made to nsswitch to ensure that SSSD would function properly.
- Refactored the localusers script and added the ability to use '!' as a prefix
  modifier to note that the entry's password should never expire.
- Changed all instances of defined(Class['foo']) to defined('foo') per the
  directions from the Puppet mailing list.
- Updated sudoers entry in common::stock::workstation_lockdown to allow admins
  to run puppetca.
- Updated yum repos to look in "Local/noarch" and "Local/${architecture}"
  instead of "Local".
- Updated 'Updates' repo to use 'operatingsystemmajrelease' instead of 'operatingsystemrelease'.
- Updated to use concat_build and concat_fragment types.

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Fri Dec 10 2010 Maintenance - 1.0-4
- Addition of an h2n function for translating hostnames to network addresses.
- common::base_apps has been modified to allow base_apps overridable.
- base_apps is no longer included in common by default, but it is included in
  base_config

* Fri Nov 05 2010 Maintenance - 1.0-3
- Ensure that at.allow has permissions of 600
- Change the mode on /etc/cron.allow to 600
- The logic for making something a DNS server was overriding the actual
  placement of the resolv.conf entries.
- Modified ip_is_me to:
  - Not break out of the loop in the middle as this caused Illegal Jump
    Exception
  - Force args to an array to only snag the first entry and split on that
  - Have more accurate documentation
  - Split on ',' on the interfaces instead of assuming (incorrectly) that is is
    an array
- Added new acpid init script to restart haldaemon on failure.
- Added incrond support and an associated class.
- Man and info page packages, as well as slocate can now be optionally
  installed. They are installed by default but have been broken out into
  common::base_config if you wish to do otherwise in a custom configuration.

* Tue Oct 26 2010 Maintenance - 1.0-2
- Converting all spec files to check for directories prior to copy.

* Mon Oct 04 2010 Maintenance
1.0-1
- Added a function 'ip_is_me' to determine if a passed IP address exists on the current system.
- Added support for auto-building the caching nameserver if '127.0.0.1' is the
  first item in the list of passed DNS servers to resolv::add_entry
- Modified the permissions on host.conf to ensure that unnecessary audit logs are not generated.

* Wed Jun 02 2010 Maintenance
1.0-0
- Added a script/class/define to allow users to set up dynamic system
  swappiness should they so desire.
- Refactor and Doc
- resolv is now common::resolv
- Added add_hosts function

* Thu May 27 2010 Maintenance
0.1-38
- Added defines to allow common::sysctl::net settings to be configured.
- Added defines to allow common::sysctl::net::advanced settings to be
  configured.
- Added option to common::sysctl::net::conf to use ktune package/service to
  manage sysctl settings
- Updated to not manage ktune if ktune option not set
- Updated the template to make the updated common::yum::update_schedule
  actually work.

* Wed May 26 2010 Maintenance
0.1-37
- Added common::at to manage /etc/at.allow
- Added common::cron to manage /etc/cron.allow
- Modified the common::yum::update_schedule function to allow for disabling
  repos from the nightly cron job

* Fri May 14 2010 Maintenance
0.1-35
- Added proper include for 'sysctl'
- Removed ELinks from the list of installed default applications.

* Wed May 12 2010 Maintenance
0.1-34
- Removed the has_service_acpid fact since we're now including it in the common
  applications.
- Added the has_clustering fact and tied the start of acpid to whether or not
  clustering is running on your system. Acpid should not run if clustering is
  enabled.

* Fri May 07 2010 Maintenance
0.1-33
- Added acpid to the list of installed/running default applications.

* Thu Apr 29 2010 Maintenance
0.1-32
- Changed operatingsystemrelease to operatingsystemmajrelease since RHEL5.5 shows as 5.5
 and not 5.

* Wed Mar 17 2010 Maintenance
0.1-31
- A massive refactor of the pupmod-common codebase. This is the beginning of a
  complete code overhaul.
- The nightly yum update job is now silent by default so that you don't get
  daily logs of OK behaviour. Stderr will still be reported. This can be
  configured through the associated define.

* Tue Feb 23 2010 Maintenance
0.1-30
- Fixed a bug in passgen that would set the directory permissions to 640 instead
  of 750.
- Added dependency on pupmod-site.

* Thu Jan 28 2010 Maintenance
0.1-29
- Added randomization to the yum cron job with a default of 5 minutes.
- Cleaned up passgen and ensured that some edge cases were accounted for.

* Wed Jan 06 2010 Maintenance
0.1-28
- Added "common::sysctl::net" and "common::sysctl::net::advanced" which provide
  a set of useful network tuning parameters.
  - common::sysctl::net sets safe kernel tuning parameters
        net.ipv4.netfilter.ip_conntrack_max = 655360
        net.unix.max_dgram_qlen = 50
        net.ipv4.neigh.default.gc_thresh3 = 2048
        net.ipv4.neigh.default.gc_thresh2 = 1024
        net.ipv4.neigh.default.gc_thresh1 = 32
        net.ipv4.neigh.default.proxy_qlen = 92
        net.ipv4.neigh.default.unres_qlen = 6
        net.core.rmem_max = 16777216
        net.core.wmem_max = 16777216
        net.ipv4.tcp_rmem = 4096 98304 16777216
        net.ipv4.tcp_wmem = 4096 65535 16777216
        net.ipv4.tcp_fin_timeout = 30
        net.ipv4.tcp_rfc1337 = 1
        net.ipv4.tcp_keepalive_time = 3600
        net.core.optmem_max = 20480
        net.core.netdev_max_backlog = 2048
        net.core.somaxconn = 2048
        net.ipv4.tcp_mtu_probing = 1
        net.ipv4.tcp_no_metrics_save = 1

  - common::sysctl::net::advanced sets an unsafe tuning parameter that may be
    useful for heavily loaded systems.
        net.ipv4.tcp_tw_reuse = 1

* Wed Dec 30 2009 Maintenance
0.1-27
  - Modified the passgen function to now have the following properties:
  - passgen(unique_id) -> Returns the stored password for 'unique_id' if there
    is one, if there is not, it generates a new password and returns that.
  - All other properties remain the same.

* Tue Dec 15 2009 Maintenance
0.1-26
- Added a section to add the yum-skip-broken package to the system if using RHEL
  < 5.3
- $dns_search and $dns_servers are now applied in the order that it is provided
  in the vars.pp file.  However, they are also now *space delimited* lists.
- Added a function, passgen(unique_id, password_length) to generate random
  passwords for use at a site.
- Added facts for $defaultgateway and $defaultgatewayiface.  They do what you
  would expect and return 'unknown' if there is no default gateway.

* Tue Oct 13 2009 Maintenance
0.1-25
- Fixed the yum-cron.erb template to work around Puppet Redmine Bug #2127.

* Thu Oct 8 2009 Maintenance
0.1-24
- Now include the 'common::yum' class by default.
- Added the ability to exclude packages during the nightly update.

* Tue Oct 6 2009 Maintenance
0.1-23
- Added a custom fact 'has_service_acpid' to determine whether or not the system
  has the acpid service.  This was mainly added for pupmod-gfs2.
- Added the ruby-shadow package as a base application so that users can now use
  the password feature of the native 'user' puppet type.

* Thu Oct 1 2009 Maintenance
0.1-22
- Added a custom fact 'runlevel' to obtain the current run level of the system.
- Nixed the spurious error spawned on non-IPv6 systems using the ipv6_enabled
  fact.
