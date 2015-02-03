require 'spec_helper'

describe 'os::debian::wheezy' do
  it { should compile.with_all_deps }

  it { should contain_class('os::debian') }
end
