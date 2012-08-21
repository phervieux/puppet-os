class os::debian-lenny {

  include os::debian

  # Disable PC Speaker
  kmod::blacklist {'pcspkr': }

  # Get rid of the old file
  file {'/etc/modprobe.d/blacklist':
    ensure => absent,
  }

  # general config for emacs (without temporary files ~ )
  file { "/etc/emacs/site-start.d/50c2c.el":
    ensure  => present,
    mode    => 644,
    source  => "puppet:///modules/os/etc/emacs/site-start.d/50c2c.el",
    require => Package["emacs23-nox"]
  }

  apt::preferences { "c2c-mirror":
    ensure => present,
    package => "*",
    pin => "release o=c2c",
    priority => "1001",
  }

  # SSL Configuration
  package {
    "ca-certificates": ensure => present;
  }

  # fix 7376
  package { ["openssl", "openssh-server", "openssh-client", "openssh-blacklist", "ssl-cert" ]:
    ensure => latest,
    require => Exec["apt-get_update"]
  }

  exec {"sysctl-reload":
    command     => "sysctl -p",
    refreshonly => true,
  }

  # fixes rt#14979
  cron {"Keeps a fresh apt database":
    command  => "/usr/bin/apt-get update -q=2",
    ensure   => present,
    hour     => 4,
    minute   => ip_to_cron(1),
  }
}
