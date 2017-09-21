#
# Class: firewall
#
# Deploy commented ruleset in /etc/iptables/rules.v[46].in
# and save working ones in /etc/iptables/rules.v[46]
#
class firewall (
  Optional[String] $iptables_content           = undef,
  Optional[String] $iptables_source            = undef,
  String $iptables_filename                    = $firewall::params::iptables_filename,
  String $iptables_in_filename                 = $firewall::params::iptables_in_filename,
  Optional[String] $ip6tables_content          = undef,
  Optional[String] $ip6tables_source           = undef,
  String $ip6tables_filename                   = $firewall::params::ip6tables_filename,
  String $ip6tables_in_filename                = $firewall::params::ip6tables_in_filename,
  String $group                                = $firewall::params::group,
  String $mode                                 = $firewall::params::mode,
  Stdlib::AbsolutePath $rules_dir              = $firewall::params::rules_dir,
  Array[String] $package_names                 = $firewall::params::package_names,
) inherits firewall::params {

  ensure_packages($package_names)
  $iptables_file     = "${rules_dir}/${iptables_filename}"
  $iptables_in_file  = "${rules_dir}/${iptables_in_filename}"
  $ip6tables_file    = "${rules_dir}/${ip6tables_filename}"
  $ip6tables_in_file = "${rules_dir}/${ip6tables_in_filename}"

  file { $iptables_in_file:
    content => $iptables_content,
    source  => $iptables_source,
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
    notify  => Exec['iptables-restore'],
  }
  file { [$iptables_file,$ip6tables_file]:
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
  }

  exec { 'iptables-restore':
    command     => "iptables-restore < ${iptables_in_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => Package['iptables'],
    notify      => Exec['iptables-save'],
  }
  exec { 'iptables-save':
    command     => "iptables-save > ${iptables_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => File[$iptables_file],
  }

  file { $ip6tables_in_file:
    content => $ip6tables_content,
    source  => $ip6tables_source,
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
    notify  => Exec['ip6tables-restore'],
  }

  exec { 'ip6tables-restore':
    command     => "ip6tables-restore < ${ip6tables_in_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => Package['iptables'],
    notify      => Exec['ip6tables-save'],
  }
  exec { 'ip6tables-save':
    command     => "ip6tables-save > ${ip6tables_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => File[$ip6tables_file],
  }
}
