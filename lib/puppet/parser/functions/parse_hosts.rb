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
      hostname = nil

      # Get the protocol.
      tmp_host = host.split('://')
      if tmp_host.size > 1 then
        protocol = tmp_host.first
        tmp_host = tmp_host.last
      end
      tmp_host = tmp_host.join("") if tmp_host.kind_of?(Array)

      # Split hostname and port.  IPv6 on ],  IPv4 on :
      if tmp_host.include?(']') then
        tmp_host = tmp_host.split(/[\[,\]]/)[1..-1]
      else
        tmp_host = tmp_host.split(':')
      end

      # Get the port.
      if tmp_host.size > 1 then
        port = tmp_host[-1].delete ":"
        tmp_host = tmp_host[0]
      end
      tmp_host = tmp_host.join("") if tmp_host.kind_of?(Array)

      # Get the hostname.
      hostname = tmp_host

      # Validation.
      if hostname.include? ":" then
        net_list = '[' + hostname + ']'
      else
        net_list = hostname
      end
      net_list = net_list + ':' + port if not port.nil?
      function_validate_net_list( [net_list] )

      # Build a unique list of parsed hosts.
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
