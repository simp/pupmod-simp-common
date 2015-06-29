require 'spec_helper'

describe 'parse_hosts' do
  # IPv4
  it do
    retval = scope.function_parse_hosts(["http://some.domain.net", "http://localhost.my.domain:8989", "fuu.bar.baz", "my.example.net:900"])
    expect(retval).to eq({"some.domain.net"=>{:ports=>[], :protocol=>["http"]}, "localhost.my.domain"=>{:ports=>["8989"], :protocol=>["http"]}, "fuu.bar.baz"=>{:ports=>[], :protocol=>[]}, "my.example.net"=>{:ports=>["900"], :protocol=>[]}})
  end
  # IPv6
  it do
    retval = scope.function_parse_hosts(["http://[2001:db8:1f70::999:de8:7648:6e8]:100", "http://[2001:dc8:1f70::999:de8:7648:6e8]", "[2001:dd8:1f70::bbb:de8:7648:6e8]", "[2001:de8:1f70::999:de8:7648:6e8]:100"])
    expect(retval).to eq({"2001:db8:1f70::999:de8:7648:6e8"=>{:ports=>["100"], :protocol=>["http"]}, "2001:dc8:1f70::999:de8:7648:6e8"=>{:ports=>[], :protocol=>["http"]}, "2001:dd8:1f70::bbb:de8:7648:6e8"=>{:ports=>[], :protocol=>[]}, "2001:de8:1f70::999:de8:7648:6e8"=>{:ports=>["100"], :protocol=>[]}})
  end
end
