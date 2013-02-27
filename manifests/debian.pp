class os::debian {
  #
  # Default packages
  #
  package {
    "at":             ensure => present; # usefull for reboots...
    "atop":           ensure => absent;
    "bc":             ensure => present;
    "bash-completion":ensure => present;
    "bzip2":          ensure => present;
    "cadaver":        ensure => present;
    "cron-apt":       ensure => purged; # Keeps a fresh apt database
    "curl":           ensure => present;
    "cvs":            ensure => present;
    "elinks":         ensure => present;
    "emacs21-common": ensure => absent;
    "emacs23-nox":    ensure => present; # for fredj (this comes from backports on Lenny)
    "gettext":        ensure => present;
    "iproute":        ensure => present;
    "less":           ensure => present;
    "locate":         ensure => absent;
    "lynx":           ensure => present;
    "mtr-tiny":       ensure => present;
    "patch":          ensure => present;
    "pwgen":          ensure => present;
    "rdiff-backup":   ensure => present;
    "rsync":          ensure => present;
    "screen":         ensure => present;
    "tofrodos":       ensure => present;
    "unzip":          ensure => present;
    "vim":            ensure => present;
    "xfsprogs":       ensure => present;
    "zip":            ensure => present;
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
  file { "/etc/localtime":
    ensure => present,
    source => "file:///usr/share/zoneinfo/posix/Europe/Zurich",
  }

  file { "/etc/timezone":
    ensure  => present,
    content => "Europe/Zurich\n",
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
    ["/etc/logrotate.d/atop",
     "/etc/logrotate.d/psaccs_atop",
     "/etc/logrotate.d/psaccu_atop"]:
    ensure  => absent,
    require => Package["atop"],
  }

}
