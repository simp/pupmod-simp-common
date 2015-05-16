require 'spec_helper'

describe 'common::cron::add_user' do

  let(:title){'simp'}

  it { should compile.with_all_deps }
  it { should create_class('common::cron') }
  it { should create_concat_fragment("cron+#{title}.user").with_content("#{title}\n") }
end
