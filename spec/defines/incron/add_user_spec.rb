require 'spec_helper'

describe 'common::incron::add_user' do

  let(:title){'simp'}

  it { should compile.with_all_deps }
  it { should create_class('common::incron') }
  it { should create_concat_fragment("incron+#{title}.user").with_content("#{title}\n") }
end
