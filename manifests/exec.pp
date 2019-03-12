# @api private
# This class handles iptables exec actions. Avoid modifying private classes.
class iptables::exec {
  # restrict access to rulesets
  File {
    ensure => file,
    owner  => 0,
    group  => $iptables::group,
    mode   => $iptables::mode,
  }

  if $iptables::use_snippets {
    # 1) aggregate the snippets
    # 2) test the aggregated file and copy it the .in file if it validated
    # 3) load/restore the .in file into the kernel

    exec { 'iptables-aggregate':
      command => "/bin/cat ${iptables::snippet_dir}/*.v4 > ${iptables::iptables_aggregated_file}",
      umask   => '0077',
      # only if missing/empty aggregated file or if aggregated file is older than snippet dir
      onlyif  => "[ ! -s '${iptables::iptables_aggregated_file}' ] || [ '${iptables::iptables_aggregated_file}' -ot '${iptables::snippet_dir}' ]",
    }
    exec { 'ip6tables-aggregate':
      command => "/bin/cat ${iptables::snippet_dir}/*.v6 > ${iptables::ip6tables_aggregated_file}",
      umask   => '0077',
      # only if missing/empty aggregated file or if aggregated file is older than snippet dir
      onlyif  => "[ ! -s '${iptables::ip6tables_aggregated_file}' ] || [ '${iptables::ip6tables_aggregated_file}' -ot '${iptables::snippet_dir}' ]",
    }

    # cannot go in iptables::config due to dependency ordering
    file { $iptables::iptables_in_file:
      source       => $iptables::iptables_aggregated_file,
      validate_cmd => "${iptables::iptables_restore} --test < %",
      require      => Exec['iptables-aggregate'],
      notify       => Exec['iptables-restore'],
    }
    file { $iptables::ip6tables_in_file:
      source       => $iptables::ip6tables_aggregated_file,
      validate_cmd => "${iptables::ip6tables_restore} --test < %",
      require      => Exec['ip6tables-aggregate'],
      notify       => Exec['ip6tables-restore'],
    }
  }

  exec { 'iptables-restore':
    command     => "${iptables::iptables_restore} < ${iptables::iptables_in_file}",
    refreshonly => true,
    notify      => Exec['iptables-save'],
  }
  exec { 'ip6tables-restore':
    command     => "${iptables::ip6tables_restore} < ${iptables::ip6tables_in_file}",
    refreshonly => true,
    notify      => Exec['ip6tables-save'],
  }

  exec { 'iptables-save':
    command     => "${iptables::iptables_save} > ${iptables::iptables_file}",
    refreshonly => true,
  }
  exec { 'ip6tables-save':
    command     => "${iptables::ip6tables_save} > ${iptables::ip6tables_file}",
    refreshonly => true,
  }
}
