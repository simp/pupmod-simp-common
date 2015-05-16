require 'spec_helper'

describe 'common::at::add_user' do

  let(:title){'simp'}

  it { should compile.with_all_deps }
  it { should create_class('common::at') }
  it { should create_concat_fragment("at+#{title}.user").with_content("#{title}\n") }
end
