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

      # Initialize.
      protocol = nil
      port = nil

      # Determine host, port, protocol
      tmp_host = host.split(':')
      if  tmp_host.size == 1
        hostname = host
      else
        # If we find ://, set the protocol. Otherwise, assume
        # we are dealing with a port.
        if tmp_host[1].include? "//"
          protocol = tmp_host[0]
          hostname = tmp_host[1].delete "//"
          port = tmp_host[2] if tmp_host[2]
        else
          hostname = tmp_host[0]
          port = tmp_host[1]
        end
      end

      net_list = hostname
      net_list = net_list + ':' + port if not port.nil?
      function_validate_net_list( [net_list] )

      if not parsed_hosts.key?(hostname)
        parsed_hosts[hostname] = {}
        parsed_hosts[hostname][:ports] = []
        parsed_hosts[hostname][:protocol] = []
      end
      if not port.nil?
        parsed_hosts[hostname][:ports] << port if not parsed_hosts[hostname][:ports].include? port
      end
      if not protocol.nil?
        parsed_hosts[hostname][:protocol] << protocol if not parsed_hosts[hostname][:protocol].include? protocol
      end
    end
    parsed_hosts
  end
end
