require 'spec_helper'
describe 'os::centos' do
  let (:node) { 'foo.example.com' }

  it { should compile.with_all_deps }

  it { should contain_host('foo.example.com') }

  it { should contain_augeas('set hostname') }

  it { should contain_exec('set hostname') }
end
