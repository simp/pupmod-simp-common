#
# tmp_mounts.rb
#
# This fact provides information about /tmp, /var/tmp, and /dev/shm should they
# be present on the system.
#
# TODO: This should be completely replaced by this
# https://github.com/kwilczynski/facter-facts/blob/master/mounts.rb once Facter
# supports data structures and the code has been updated to capture all
# information. Yes, a lot of this is borrowed from there.
#
# Right now, this will return *three* facts based on each location and,
# unfortunately, you can't have symbols in fact names so we've substituted '/'
# with '_' and prepended 'tmp_mount'.
#
require 'facter'

target_dirs = %w(
  /tmp
  /var/tmp
  /dev/shm
)

mount_list = Hash.new

Facter::Util::Resolution.exec('/bin/cat /etc/mtab 2> /dev/null').each_line do |line|
  line.strip!

  next if line.empty? or line.match(/^none/)

  mount = line.split(/\s+/)

  # If there are multiple mounts at the same mountpoint, this picks up the very
  # last one, which is what you want.
  mount_list[mount[1]] = {
    :path   => mount[0],
    :fstype => mount[2],
    :opts   => mount[3].gsub(/'|"/,''),
    :freq   => mount[4],
    :passno => mount[5]
  }
end

target_dirs.each do |dir|

  Facter.add("tmp_mount#{dir.gsub('/','_')}") do
    confine :kernel => :linux
    setcode do
      retval = nil
      mount_list[dir] and retval = mount_list[dir][:opts]
      retval
    end
  end

  Facter.add("tmp_mount_path#{dir.gsub('/','_')}") do
    confine :kernel => :linux
    setcode do
      retval = nil
      mount_list[dir] and retval = mount_list[dir][:path]
      retval
    end
  end

  Facter.add("tmp_mount_fstype#{dir.gsub('/','_')}") do
    confine :kernel => :linux
    setcode do
      retval = nil
      mount_list[dir] and retval = mount_list[dir][:fstype]
      retval
    end
  end

end
