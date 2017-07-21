#
# Class: firewall
#
# Deploy commented ruleset in /etc/iptables/rules.v[46].in
# and save working ones in /etc/iptables/rules.v[46]
#
class firewall (
  Optional[String] $iptables_content           = undef,
  Optional[String] $iptables_source            = undef,
  Stdlib::AbsolutePath $iptables_rule_file     = '/etc/iptables/rules.v4',
  Stdlib::AbsolutePath $iptables_rule_in_file  = '/etc/iptables/rules.v4.in',
  Optional[String] $ip6tables_content          = undef,
  Optional[String] $ip6tables_source           = undef,
  Stdlib::AbsolutePath $ip6tables_rule_file    = '/etc/iptables/rules.v6',
  Stdlib::AbsolutePath $ip6tables_rule_in_file = '/etc/iptables/rules.v6.in',
  String $group                                = 'sudo',
  String $mode                                 = '0640',
) {

  ensure_packages(['iptables','iptables-persistent'])

  file { $iptables_rule_in_file:
    content => $iptables_content,
    source  => $iptables_source,
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
    notify  => Exec['iptables-restore'],
  }
  file { [$iptables_rule_file,$ip6tables_rule_file]:
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
  }

  exec { 'iptables-restore':
    command     => "iptables-restore < ${iptables_rule_in_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => Package['iptables'],
    notify      => Exec['iptables-save'],
  }
  exec { 'iptables-save':
    command     => "iptables-save > ${iptables_rule_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => File[$iptables_rule_file],
  }

  file { $ip6tables_rule_in_file:
    content => $ip6tables_content,
    source  => $ip6tables_source,
    owner   => 0,
    group   => $group,
    mode    => $mode,
    require => Package['iptables-persistent'],
    notify  => Exec['ip6tables-restore'],
  }

  exec { 'ip6tables-restore':
    command     => "ip6tables-restore < ${ip6tables_rule_in_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => Package['iptables'],
    notify      => Exec['ip6tables-save'],
  }
  exec { 'ip6tables-save':
    command     => "ip6tables-save > ${ip6tables_rule_file}",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    require     => File[$ip6tables_rule_file],
  }
}
