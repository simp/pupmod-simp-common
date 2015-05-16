module Puppet::Parser::Functions
  newfunction(
    :strip_ports,
    :type => :rvalue,
    :arity => 1,
    :doc  => 'Take an array of items that may contain port numbers and
              appropriately return only the non-port portion. Works with
              hostnames, IPv4, and IPv6.'
  ) do |args|

    # Variable Assignment
    hosts = args.flatten

    Puppet::Parser::Functions.autoloader.loadall
    function_validate_net_list( [ hosts ] )

    stripped_hosts = []
    hosts.each do |host|
      tmp_host = host.split(':')

      # This is just an IPv6 record
      if tmp_host.size == 1 or tmp_host.last.include?(']') then
        stripped_hosts << host
      else
        stripped_hosts << tmp_host[0..-2].join(':')
      end
    end

    stripped_hosts.uniq
  end
end
