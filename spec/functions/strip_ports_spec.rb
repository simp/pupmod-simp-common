require 'spec_helper'

describe 'strip_ports' do
  # IPv4
  it do
    retval = scope.function_strip_ports(["http://some.domain.net",
                                         "http://some.domain.net",
                                         "http://localhost.my.domain:8989",
                                         "fuu.bar.baz",
                                         "my.example.net:900"])
    expect(retval).to eq(["some.domain.net", "localhost.my.domain", "fuu.bar.baz", "my.example.net"])
  end
  # IPv6
  it do
    retval = scope.function_strip_ports(["http://[2001:db8:1f70::999:de8:7648:6e8]:100",
                                         "http://[2001:dc8:1f70::999:de8:7648:6e8]",
                                         "[2001:dd8:1f70::bbb:de8:7648:6e8]",
                                         "[2001:de8:1f70::999:de8:7648:6e8]:100"])
    expect(retval).to eq(["2001:db8:1f70::999:de8:7648:6e8",
                          "2001:dc8:1f70::999:de8:7648:6e8",
                          "2001:dd8:1f70::bbb:de8:7648:6e8",
                          "2001:de8:1f70::999:de8:7648:6e8"])
  end
end
