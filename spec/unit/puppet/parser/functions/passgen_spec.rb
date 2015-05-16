#!/usr/bin/env ruby -S rspec
require 'spec_helper'

describe Puppet::Parser::Functions.function(:passgen) do
  let(:scope) do
    PuppetlabsSpec::PuppetInternals.scope
  end

  let(:default_chars) do
    (("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a).map do|x|
      x = Regexp.escape(x)
    end
  end

  let(:safe_special_chars) do
    ['@','%','-','_','+','=','~'].map do |x|
      x = Regexp.escape(x)
    end
  end

  let(:unsafe_special_chars) do
    (((' '..'/').to_a + ('['..'`').to_a + ('{'..'~').to_a)).map do |x|
      x = Regexp.escape(x)
    end - safe_special_chars
  end

  subject do
    function_name = Puppet::Parser::Functions.function(:passgen)
    scope.method(function_name)
  end

  it 'should run successfully with default arguments' do
    expect {
      subject.call(['spectest'])
    }.to_not raise_error
  end

  it 'should return a password that is 32 alphanumeric characters long by default' do
    result = subject.call(['spectest'])
    result.length.should eql(32)
    result.should match(/^(#{default_chars.join('|')})+$/)
  end

  it 'should work with a String length' do
    result = subject.call([ 'spectest', {'length' => '32'} ])
    result.length.should eql(32)
    result.should match(/^(#{default_chars.join('|')})+$/)
  end

  it 'should return a password that is 8 alphanumeric characters long if length is 8' do
    result = subject.call([ 'spectest', {'length' => 8} ])
    result.length.should eql(8)
    result.should match(/^(#{default_chars.join('|')})+$/)
  end

  it 'should return a password that contains "safe" special characters if complexity is 1' do
    result = subject.call([ 'spectest', {'complexity' => 1} ])
    result.length.should eql(32)
    result.should match(/(#{default_chars.join('|')})/)
    result.should match(/(#{(safe_special_chars).join('|')})/)
    result.should_not match(/(#{(unsafe_special_chars).join('|')})/)
  end

  it 'should return a password that contains "safe" special characters if complexity is 1' do
    result = subject.call([ 'spectest', {'complexity' => 1} ])
    result.length.should eql(32)
    result.should match(/(#{default_chars.join('|')})/)
    result.should match(/(#{(safe_special_chars).join('|')})/)
    result.should_not match(/(#{(unsafe_special_chars).join('|')})/)
  end

  it 'should return a password that contains "safe" special characters if complexity is 1' do
    result = subject.call([ 'spectest', {'complexity' => 1} ])
    result.length.should eql(32)
    result.should match(/(#{default_chars.join('|')})/)
    result.should match(/(#{(safe_special_chars).join('|')})/)
    result.should_not match(/(#{(unsafe_special_chars).join('|')})/)
  end

  it 'should work with a String complexity' do
    result = subject.call([ 'spectest', {'complexity' => '1'} ])
    result.length.should eql(32)
    result.should match(/(#{default_chars.join('|')})/)
    result.should match(/(#{(safe_special_chars).join('|')})/)
    result.should_not match(/(#{(unsafe_special_chars).join('|')})/)
  end

  it 'should return a password that contains all special characters if complexity is 2' do
    result = subject.call([ 'spectest', {'complexity' => 2} ])
    result.length.should eql(32)
    result.should match(/(#{default_chars.join('|')})/)
    result.should match(/(#{(unsafe_special_chars).join('|')})/)
  end

  it 'should return the next to last created password if "last" is true' do
    first_result = subject.call([ 'spectest', {'length' => 32} ])
    second_result = subject.call([ 'spectest', {'length' => 33} ])
    third_result = subject.call([ 'spectest', {'length' => 34} ])
    subject.call([ 'spectest', 'last' ]).should eql(second_result)
  end

  it 'should return the current password if "last" is true but there is no previous password' do
    result = subject.call([ 'spectest', {'length' => 32} ])
    subject.call([ 'spectest', 'last' ]).should eql(result)
  end

  it 'should return an md5 hash of the password if passed "md5"' do
    result = subject.call([ 'spectest', {'hash' => 'md5'} ])
    result.should match(/^\$1\$/)
  end

  it 'should return an sha256 hash of the password if passed "sha256"' do
    result = subject.call([ 'spectest', {'hash' => 'sha256'} ])
    result.should match(/^\$5\$/)
  end

  it 'should return an sha512 hash of the password if passed "sha512"' do
    result = subject.call([ 'spectest', {'hash' => 'sha512'} ])
    result.should match(/^\$6\$/)
  end

  ## Legacy Options
  it 'should return the next to last created password if the second argument is "last"' do
    first_result = subject.call([ 'spectest' ])
    second_result = subject.call([ 'spectest', 33 ])
    subject.call([ 'spectest', 'last' ]).should eql(first_result)
  end

  it 'should return a password of length 8 if the second argument is "8"' do
    result = subject.call([ 'spectest' ])
    subject.call([ 'spectest', 8 ]).length.should eql(8)
  end
end
