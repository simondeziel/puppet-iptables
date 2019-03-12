# @api private
# This class handles iptables config. Avoid modifying private classes.
class iptables::config {
  # restrict access to rulesets
  File {
    ensure => file,
    owner  => 0,
    group  => $iptables::group,
    mode   => $iptables::mode,
  }

  file { $iptables::iptables_file:
    notify => Exec['iptables-restore'],
  }
  file { $iptables::ip6tables_file:
    notify => Exec['ip6tables-restore'],
  }

  if $iptables::use_snippets {
    file { $iptables::snippet_dir:
      ensure  => directory,
      recurse => true,
      purge   => true,
      owner   => 0,
      group   => 0,
      mode    => '0755',
    }
  } else {
    file { $iptables::iptables_in_file:
      content      => $iptables::iptables_content,
      source       => $iptables::iptables_source,
      validate_cmd => "${iptables::iptables_restore} --test < %",
      notify       => Exec['iptables-restore'],
    }
    file { $iptables::ip6tables_in_file:
      content      => $iptables::ip6tables_content,
      source       => $iptables::ip6tables_source,
      validate_cmd => "${iptables::ip6tables_restore} --test < %",
      notify       => Exec['ip6tables-restore'],
    }
    file { [$iptables::iptables_aggregated_file,$iptables::ip6tables_aggregated_file]:
      ensure => absent,
    }
    file { $iptables::snippet_dir:
      ensure => absent,
      force  => true,
    }
  }
}
