#
# Class: firewall
#
# Deploy commented ruleset in /etc/iptables/rules.v[46].in
# and save working ones in /etc/iptables/rules.v[46]
#
class firewall (
  Optional[String] $iptables_content      = undef,
  Optional[String] $iptables_source       = undef,
  String $iptables_filename               = $firewall::params::iptables_filename,
  String $iptables_in_filename            = $firewall::params::iptables_in_filename,
  Optional[String] $ip6tables_content     = undef,
  Optional[String] $ip6tables_source      = undef,
  String $ip6tables_filename              = $firewall::params::ip6tables_filename,
  String $ip6tables_in_filename           = $firewall::params::ip6tables_in_filename,
  String $group                           = $firewall::params::group,
  String $mode                            = $firewall::params::mode,
  Stdlib::AbsolutePath $rules_dir         = $firewall::params::rules_dir,
  Stdlib::AbsolutePath $snippet_dir       = $firewall::params::snippet_dir,
  Array[String] $package_names            = $firewall::params::package_names,
  Stdlib::AbsolutePath $iptables_save     = $firewall::params::iptables_save,
  Stdlib::AbsolutePath $ip6tables_save    = $firewall::params::ip6tables_save,
  Stdlib::AbsolutePath $iptables_restore  = $firewall::params::iptables_restore,
  Stdlib::AbsolutePath $ip6tables_restore = $firewall::params::ip6tables_restore,
) inherits firewall::params {

  ensure_packages($package_names)
  $iptables_file     = "${rules_dir}/${iptables_filename}"
  $iptables_in_file  = "${rules_dir}/${iptables_in_filename}"
  $ip6tables_file    = "${rules_dir}/${ip6tables_filename}"
  $ip6tables_in_file = "${rules_dir}/${ip6tables_in_filename}"

  file { $snippet_dir:
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => '0755',
    require => Package['iptables-persistent'],
  }
  file { $iptables_in_file:
    content      => $iptables_content,
    source       => $iptables_source,
    owner        => 0,
    group        => $group,
    mode         => $mode,
    validate_cmd => "${iptables_restore} --test < %",
    require      => Package['iptables-persistent'],
    notify       => Exec['iptables-restore'],
  }
  file { [$iptables_file,$ip6tables_file]:
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
  }

  exec { 'iptables-restore':
    command     => "${iptables_restore} < ${iptables_in_file}",
    refreshonly => true,
    require     => Package['iptables'],
    notify      => Exec['iptables-save'],
  }
  exec { 'iptables-save':
    command     => "${iptables_save} > ${iptables_file}",
    refreshonly => true,
    require     => File[$iptables_file],
  }

  file { $ip6tables_in_file:
    content      => $ip6tables_content,
    source       => $ip6tables_source,
    owner        => 0,
    group        => $group,
    mode         => $mode,
    validate_cmd => "${ip6tables_restore} --test < %",
    require      => Package['iptables-persistent'],
    notify       => Exec['ip6tables-restore'],
  }

  exec { 'ip6tables-restore':
    command     => "${ip6tables_restore} < ${ip6tables_in_file}",
    refreshonly => true,
    require     => Package['iptables'],
    notify      => Exec['ip6tables-save'],
  }
  exec { 'ip6tables-save':
    command     => "/sbin/ip6tables-save > ${ip6tables_file}",
    refreshonly => true,
    require     => File[$ip6tables_file],
  }
}
