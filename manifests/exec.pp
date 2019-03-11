# @api private
# This class handles iptables exec actions. Avoid modifying private classes.
class iptables::exec inherits iptables {
  # restrict access to rulesets
  File {
    owner => 0,
    group => $group,
    mode  => $mode,
  }

  if $use_snippets {
    # 1) aggregate the snippets
    # 2) test the aggregated file and copy it the .in file if it validated
    # 3) load/restore the .in file into the kernel

    exec { 'iptables-aggregate':
      command => "/bin/cat ${snippet_dir}/*.v4 > ${iptables_aggregated_file}",
      umask   => '0077',
      # only if missing/empty aggregated file or if aggregated file is older than snippet dir
      onlyif  => "[ ! -s \"${iptables_aggregated_file}\" ] || [ \"${iptables_aggregated_file}\" -ot \"${snippet_dir}\" ]",
    }
    exec { 'ip6tables-aggregate':
      command => "/bin/cat ${snippet_dir}/*.v6 > ${ip6tables_aggregated_file}",
      umask   => '0077',
      # only if missing/empty aggregated file or if aggregated file is older than snippet dir
      onlyif  => "[ ! -s \"${ip6tables_aggregated_file}\" ] || [ \"${ip6tables_aggregated_file}\" -ot \"${snippet_dir}\" ]",
    }

    # cannot go in iptables::config due to dependency ordering
    file { $iptables_in_file:
      ensure       => file,
      source       => $iptables_aggregated_file,
      validate_cmd => "${iptables_restore} --test < %",
      require      => Exec['iptables-aggregate'],
      notify       => Exec['iptables-restore'],
    }
    file { $ip6tables_in_file:
      ensure       => file,
      source       => $ip6tables_aggregated_file,
      validate_cmd => "${ip6tables_restore} --test < %",
      require      => Exec['ip6tables-aggregate'],
      notify       => Exec['ip6tables-restore'],
    }
  }

  exec { 'iptables-restore':
    command     => "${iptables_restore} < ${iptables_in_file}",
    refreshonly => true,
    notify      => Exec['iptables-save'],
  }
  exec { 'ip6tables-restore':
    command     => "${ip6tables_restore} < ${ip6tables_in_file}",
    refreshonly => true,
    notify      => Exec['ip6tables-save'],
  }

  exec { 'iptables-save':
    command     => "${iptables_save} > ${iptables_file}",
    refreshonly => true,
  }
  exec { 'ip6tables-save':
    command     => "${ip6tables_save} > ${ip6tables_file}",
    refreshonly => true,
  }
}
