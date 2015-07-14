module Puppet::Parser::Functions
  newfunction(:validate_net_list, :doc => <<-'ENDHEREDOC') do |args|
    Validate that a passed list (Array or single String) of networks
    is filled with valid IP addresses or hostnames. Hostnames are checked per
    RFC 1123. Ports appended with a colon (:) are allowed.

    There is a second, optional argument that is a regex of strings that should
    be ignored from the list. Omit the beginning and ending '/' delimiters.

    The following values will pass:

      $client_nets = ['10.10.10.0/24','1.2.3.4','1.3.4.5:400']
      validate_net_list($client_nets)

      $client_nets = '10.10.10.0/24'
      validate_net_list($client_nets)

      $client_nets = ['10.10.10.0/24','1.2.3.4','any','ALL']
      validate_net_list($client_nets,'^(any|ALL)$')

    The following values will fail:

      $client_nets = '10.10.10.0/24,1.2.3.4'
      validate_net_list($client_nets)

      $client_nets = 'bad stuff'
      validate_net_list($client_nets)

    ENDHEREDOC

    if ((args.length < 1) || (args.length > 2))
      raise Puppet::ParseError,("validate_net_list(): Must pass [net_list], (optional exclusion regex).")
    end

    net_list = args.shift
    unless (net_list.is_a?(String) || net_list.is_a?(Array))
      raise Puppet::ParseError,("validate_net_list(): net_list must be either a String or Array")
    end
    net_list = Array(net_list.dup)

    str_match = args.shift

    if str_match
      str_match = Regexp.new(Regexp.escape(str_match))
      net_list.delete_if{|x| str_match.match(x)}
    end

    require File.expand_path(File.dirname(__FILE__) + '/../../../puppetx/simp/common.rb')
    require 'ipaddr'

    # Needed to use other functions inside of this one
    Puppet::Parser::Functions.autoloader.loadall

    net_list.each do |net|
      begin
        # Do we have a port?
        host,port = PuppetX::SIMP::Common.split_port(net)
        function_validate_port(Array(port)) if (port && !port.empty?)

        # Just skip it if it's a hostname.
        next if PuppetX::SIMP::Common.hostname?(host)

        ip = IPAddr.new(host)
        unless (ip.ipv4? || ip.ipv6?)
         # This is just here to re-use the rescue below.
         raise ArgumentError
        end
      rescue ArgumentError
        raise Puppet::ParseError,("validate_net_list(): '#{net}' is not a valid network.")
      end
    end
  end
end
