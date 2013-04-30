class os::debian {
  #
  # Default packages
  #
  package {
    "at":             ensure => present; # usefull for reboots...
    "bc":             ensure => present;
    "bash-completion":ensure => present;
    "bzip2":          ensure => present;
    "cadaver":        ensure => present;
    "cron-apt":       ensure => purged; # Keeps a fresh apt database
    "emacs21-common": ensure => absent;
    "gettext":        ensure => present;
    "iproute":        ensure => present;
    "locate":         ensure => absent;
    "lynx":           ensure => present;
    "tofrodos":       ensure => present;
    "xfsprogs":       ensure => present;
  }
  
  # Umask, etc.
  file { "/etc/profile":
    ensure => present,
    mode   => 644,
    source => "puppet:///modules/os/etc/profile-debian",
  }

  file {"/etc/profile.d":
    ensure => directory
  }

  # Timezone
  file { '/etc/timezone':
    ensure  => present,
    content => "Europe/Zurich\n",
    notify  => Exec ['reconfigure tzdata'],
  }
  exec { 'reconfigure tzdata':
    command     => 'dpkg-reconfigure -f noninteractive tzdata',
    refreshonly => true,
  }

  # Kernel
  file { "/etc/modules":
    ensure => present,
  }

  file {"/etc/adduser.conf":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("os/etc/adduser.conf.erb"),
  }

  # $LANG
  file { "/etc/environment":
    ensure => present,
    mode   => 644,
    source => "puppet:///modules/os/etc/environment",
    owner  => root,
    group  => root,
  }

  file {
    [
      '/etc/logrotate.d/atop',
      '/etc/logrotate.d/psaccs_atop',
      '/etc/logrotate.d/psaccu_atop'
    ]:
    ensure  => absent,
  }

}
