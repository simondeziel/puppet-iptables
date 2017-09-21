# @api private
# This class handles firewall exec actions. Avoid modifying private classes.
class firewall::exec inherits firewall {
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
