require 'spec_helper'

describe 'common::incron::add_system_table ' do

  let(:title){'simp_test'}
  let(:params){{
    :path => '/tmp/foo',
    :mask => ['IN_MODIFY','IN_MOVE','IN_CREATE','IN_DELETE'],
    :command => '/bin/bar $@'
  }}

  it { should compile.with_all_deps }

  it { should create_file("/etc/incron.d/#{title}").with({
      :content => "#{params[:path]} #{Array(params[:mask]).join(',')} #{params[:command]}\n",
      :require => 'Package[incron]'
    })
  }

  context 'bad_mask' do
    let(:params){{
      :path => '/tmp/foo',
      :mask => ['IN_MODIFY','IN_MOVE','IN_CREATE','IN_DELETE','IN_FOO'],
      :command => '/bin/bar $@'
    }}

    it do
      expect {
        should compile.with_all_deps
      }.to raise_error(/"IN_FOO" does not/)
    end
  end

  context 'custom_content' do
    let(:params){{
      :path => '/tmp/foo',
      :custom_content => 'foo bar FTW!'
    }}

    it { should create_file("/etc/incron.d/#{title}").with({
        :content => "#{params[:custom_content]}\n",
        :require => 'Package[incron]'
      })
    }
  end
end
