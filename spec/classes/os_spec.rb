require 'spec_helper'
describe 'os' do
  context 'when on Debian wheezy' do
    let (:facts) { {
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :lsbdistcodename => 'wheezy',
    } }

    it { should compile.with_all_deps }

    it { should contain_class('os::debian-wheezy') }
  end

  context 'when on unknown Debian version' do
    let (:facts) { {
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian',
      :lsbdistcodename => 'etch',
    } }

    it 'should fail' do
      expect { should compile }.to raise_error(Puppet::Error, /Unsupported Debian version/)
    end
  end

  context 'when on RedHat' do
    let (:facts) { {
      :osfamily        => 'RedHat',
      :operatingsystem => 'RedHat',
    } }

    it { should compile.with_all_deps }

    it { should contain_class('os::centos') }
  end

  context 'when on unknown OS' do
    let (:facts) { {
      :osfamily        => 'SunOS',
      :operatingsystem => 'SunOS',
    } }

    it 'should fail' do
      expect { should compile }.to raise_error(Puppet::Error, /Unsupported OS/)
    end
  end
end
