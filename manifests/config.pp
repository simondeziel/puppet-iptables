# @api private
# This class handles firewall config. Avoid modifying private classes.
class firewall::config inherits firewall {
  # restrict access to rulesets
  File {
    owner => 0,
    group => $group,
    mode  => $mode,
  }

  file { [$iptables_file,$ip6tables_file]:
    ensure => file,
  }

  if $use_snippets {
    file { $snippet_dir:
      ensure  => directory,
      purge   => true,
      owner   => 0,
      group   => 0,
      mode    => '0755',
    }
  } else {
    file { $iptables_in_file:
      ensure       => file,
      content      => $iptables_content,
      source       => $iptables_source,
      validate_cmd => "${iptables_restore} --test < %",
      notify       => Exec['iptables-restore'],
    }
    file { $ip6tables_in_file:
      ensure       => file,
      content      => $ip6tables_content,
      source       => $ip6tables_source,
      validate_cmd => "${ip6tables_restore} --test < %",
      notify       => Exec['ip6tables-restore'],
    }
    file { [$iptables_aggregated_file,$ip6tables_aggregated_file]:
      ensure => absent,
    }
    file { $snippet_dir:
      ensure  => absent,
      force   => true,
    }
  }
}
