module Puppet::Parser::Functions
  newfunction(
    :parse_hosts,
    :type => :rvalue,
    :doc  => <<-EOM) do |args|
       Take an array of items that may contain port numbers or protocols and appropriately
       return the host information, port, and protocol as a hash.  Works with hostnames, IPv4,
       and IPv6.
  EOM

    # Defaults
    hosts = args.flatten

    # Validation
    if hosts.empty? then raise Puppet::ParseError, "You must pass a list of hosts." end
    Puppet::Parser::Functions.autoloader.loadall

    # Parse!
    parsed_hosts = {}
    hosts.each do |host|

      next if host.nil?
      tmp_host = host

      # Initialize.
      protocol = nil
      port = nil
      hostname = nil

      # Get the protocol.
      tmp_host = host.split('://') if host.include? '://'
      if tmp_host.kind_of? Array then
        protocol = tmp_host.first
        tmp_host = tmp_host.last
      end

      # Validate with the protocol stripped off
      function_validate_net_list( [tmp_host] )

      num_colon = tmp_host.count(':')
      # IPv4 no port
      if num_colon == 0 then
        hostname = tmp_host
      # IPv4 with port
      elsif num_colon == 1 then
        hostname, port = tmp_host.split(':')
      # IPv6
      else
        tmp_host = tmp_host.delete('[').split(']:')
        # With port
        if tmp_host.size > 1 then
          hostname = tmp_host.first
          port = tmp_host.last
        # Without port
        else
          hostname = tmp_host.first.delete(']')
        end
      end

      # Build a unique list of parsed hosts.
      if not parsed_hosts.key?(hostname) then
        parsed_hosts[hostname] = {
          :ports => [],
          :protocol => []
        }
      end
      if not port.nil? then
        parsed_hosts[hostname][:ports] << port if not parsed_hosts[hostname][:ports].include? port
      end
      if not protocol.nil? then
        parsed_hosts[hostname][:protocol] << protocol if not parsed_hosts[hostname][:protocol].include? protocol
      end
    end
    parsed_hosts
  end
end
