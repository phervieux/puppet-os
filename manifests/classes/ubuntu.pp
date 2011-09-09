class ubuntu {
  # fix 7376
  package { ["openssl", "openssh-server", "openssh-client", "openssh-blacklist", "ssl-cert" ]:
    ensure => latest,
    require => Exec["apt-get_update"]
  }

  # Default packages
  package {
    "cron": ensure => present;
    "nano": ensure => present;
    "pwgen": ensure => present;
    "vim": ensure => present;
    "curl": ensure => present;
    "mtr-tiny": ensure => present;
    "cvs": ensure => present;
    "bzip2": ensure => present;
    "cadaver": ensure => present;
    "tofrodos": ensure => present;
    "lynx": ensure => present;
    "locales": ensure => present;
  }
  
  file {"/etc/profile.d":
    ensure => directory
  }

  # Disable PC Speaker
  line {"disable pc speaker":
    line   => 'blacklist pcspkr',
    file   => '/etc/modprobe.d/blacklist.conf',
    ensure => present,
  }

  # Do not propose system upgrade
  line {
    "default release-upgrade prompt configuration removed":
      line   => 'prompt=normal',
      file   => '/etc/update-manager/release-upgrades',
      ensure => absent;
    "release-upgrade prompt configuration to none":
      line   => 'prompt=never',
      file   => '/etc/update-manager/release-upgrades',
      require=> File["/etc/update-manager/"],
      ensure => present;
  }

  file {"/etc/update-manager/":
      ensure => directory,
  }

  # Profile
  file {"/etc/profile":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 644,
    source => "puppet:///os/etc/profile-ubuntu",
  }

  # Timezone
  file { "/etc/localtime":
    ensure => present,
    source => "file:///usr/share/zoneinfo/Europe/Zurich",
  }
  file { "/etc/timezone":
    ensure  => present,
    content => "Europe/Zurich",
  }

  # Kernel
  file { "/etc/modules":
    ensure => present,
  }
}

