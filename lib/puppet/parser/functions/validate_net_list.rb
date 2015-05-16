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

    if args.length < 1 or args.length > 2 then
      raise Puppet::ParseError,("validate_net_list(): Must pass [net_list], (optional exclusion regex).")
    end

    net_list = args.shift
    unless net_list.is_a?(String) or net_list.is_a?(Array) then
      raise Puppet::ParseError,("validate_net_list(): net_list must be either a String or Array")
    end
    net_list = Array(net_list.dup)

    str_match = args.shift

    if str_match then
      str_match = Regexp.new(Regexp.escape(str_match))
      net_list.delete_if{|x| str_match.match(x)}
    end

    require File.expand_path(File.dirname(__FILE__) + '/../../../puppetx/simp/common.rb')
    require 'ipaddr'

    net_list.each do |n|
      begin
        # Just skip it if it's a hostname.
        next if PuppetX::SIMP::Common.hostname?(n)

        # Do we have a port?
        if n =~ /^([0-9.]+|(?:\[[0-9a-fA-F:]+\]))(:[0-9]+)$/
          n = $1
          p = $2

          # Is it a valid port?
          p.to_i.between?(0,65536) or raise ArgumentError
        end

        ip = IPAddr.new(n)
        if not ip.ipv4? and not ip.ipv6? then
         # This is just here to re-use the rescue below.
         raise ArgumentError
        end
      rescue ArgumentError
        raise Puppet::ParseError,("validate_net_list(): '#{n}' is not a valid network.")
      end
    end
  end
end
