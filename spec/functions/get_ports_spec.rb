require 'spec_helper'

describe 'get_ports' do
  # IPv4
  it do
    retval = scope.function_get_ports(["http://some.domain.net",
                                       "http://some.domain.net:1234",
                                       "http://localhost.my.domain:8989",
                                       "fuu.bar.baz",
                                       "my.example.net:900"])
    expect(retval).to eq(['1234', '8989', '900'])
  end
  # IPv6
  it do
    retval = scope.function_get_ports(["http://[2001:db8:1f70::999:de8:7648:6e8]:100",
                                       "http://[2001:dc8:1f70::999:de8:7648:6e8]:300",
                                       "[2001:dd8:1f70::bbb:de8:7648:6e8]",
                                       "[2001:de8:1f70::999:de8:7648:6e8]:100"])
    expect(retval).to eq(['100', '300'])
  end
end
