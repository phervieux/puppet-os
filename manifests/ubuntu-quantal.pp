class os::ubuntu-quantal {
  # fix 7376
  package {['openssl', 'openssh-server', 'openssh-client',
            'openssh-blacklist', 'ssl-cert']:
    ensure  => latest,
    require => Exec['apt-get_update'],
  }

  # Default packages
  package {['cron', 'nano', 'pwgen', 'vim', 'curl', 'mtr-tiny', 'cvs',
            'bzip2', 'cadaver', 'tofrodos', 'lynx', 'locales']:
    ensure => present;
  }

  file {'/etc/profile.d':
    ensure => directory
  }

  # Disable PC Speaker
  kmod::blacklist {'pcspkr': }

  # Do not propose system upgrade
  augeas::lens {'apt_update_manager':
    lens_source => 'puppet:///modules/os/lenses/apt_update_manager.aug',
    test_source => 'puppet:///modules/os/lenses/test_apt_update_manager.aug',
  }

  augeas {'default release-upgrade prompt configuration removed':
    incl    => '/etc/update-manager/release-upgrades',
    lens    => 'Apt_Update_Manager.lns',
    changes => [
      # Remove other versions of the key
      'rm DEFAULT/*[label() =~ regexp("[Pp][Rr][Oo][Mm][Pp][Tt]")]',
      'set DEFAULT/Prompt normal',
    ],
  }

  file {'/etc/update-manager/':
      ensure => directory,
  }

  # Profile
  file {'/etc/profile':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/os/etc/profile-ubuntu',
  }

  # Kernel
  file { '/etc/modules':
    ensure => present,
  }
}

