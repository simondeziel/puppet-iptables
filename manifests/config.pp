# @api private
# This class handles firewall config. Avoid modifying private classes.
class firewall::config inherits firewall {
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
}
