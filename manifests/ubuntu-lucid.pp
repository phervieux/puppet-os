class os::ubuntu-lucid {
  # fix 7376
  package {['openssl', 'openssh-server', 'openssh-client',
            'openssh-blacklist', 'ssl-cert']:
    ensure  => latest,
    require => Exec['apt-get_update'],
  }

  # Default packages
  package {['cron', 'nano',
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
    stock_since => '1.0.0',
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

  # Timezone
  file { '/etc/localtime':
    ensure => present,
    source => 'file:///usr/share/zoneinfo/Europe/Zurich',
  }
  file { '/etc/timezone':
    ensure  => present,
    content => 'Europe/Zurich',
  }

  # Kernel
  file { '/etc/modules':
    ensure => present,
  }
}

