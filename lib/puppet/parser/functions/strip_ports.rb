module Puppet::Parser::Functions
  newfunction(
    :strip_ports,
    :type => :rvalue,
    :doc  => <<-EOM) do |args|
       Take an array of items that may contain port numbers and appropriately return
       the non-port portion. Works with hostnames, IPv4, and IPv6.

      Arguments: hosts
        - 'hosts'        => Array of hostnames which may contain port numbers.
  EOM

    raise Puppet::ParseError, "You must pass a list of hosts." if args.empty?

    args = [args] if args.kind_of?(String)
    hosts = args.flatten
    stripped_hosts = function_parse_hosts([hosts]).keys.uniq

    stripped_hosts
  end
end