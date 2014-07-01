require 'spec_helper'
describe 'os::centos' do
  let (:node) { 'foo.example.com' }

  let (:facts) { {
    :ipaddress => '10.0.0.1'
  } }

  let (:pre_condition) {
    "Exec { path => '/foo' }"
  }

  it { should compile.with_all_deps }

  it { should contain_host('foo.example.com') }

  it { should contain_augeas('set hostname') }

  it { should contain_exec('set hostname') }
end
