#
# Define: iptables::snippet
#
# Deploy commented ruleset snippets in /etc/iptables/snippet/${name}.v[46]
#
define iptables::snippet (
  Optional[String] $iptables_content       = undef,
  Optional[String] $iptables_source        = undef,
  Optional[String] $ip6tables_content      = undef,
  Optional[String] $ip6tables_source       = undef,
  String $group                            = $iptables::group,
  String $mode                             = $iptables::mode,
) {
  if $name !~ /^\d\d/ {
    fail("${module_name} the name of the snippet must begin with at least 2 digits, like 01-input.")
  }

  # restrict access to rulesets
  File {
    owner => 0,
    group => $group,
    mode  => $mode,
  }

  file { "${iptables::snippet_dir}/${name}.v4":
    content => $iptables_content,
    source  => $iptables_source,
    notify  => Exec['iptables-aggregate'],
  }
  file { "${iptables::snippet_dir}/${name}.v6":
    content => $ip6tables_content,
    source  => $ip6tables_source,
    notify  => Exec['ip6tables-aggregate'],
  }
}
