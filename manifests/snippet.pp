#
# Define: firewall::snippet
#
# Deploy commented ruleset snippets in /etc/iptables/snippet/${name}.v[46]
#
define firewall::snippet (
  Variant[Integer[10,99],String[2]] $order,
  Optional[String] $iptables_content       = undef,
  Optional[String] $iptables_source        = undef,
  Optional[String] $ip6tables_content      = undef,
  Optional[String] $ip6tables_source       = undef,
  String $group                            = $firewall::group,
  String $mode                             = $firewall::mode,
) {
  # restrict access to rulesets
  File {
    owner => 0,
    group => $group,
    mode  => $mode,
  }

  file { "${firewall::snippet_dir}/${order}-${name}.v4":
    content => $iptables_content,
    source  => $iptables_source,
    notify  => Exec['iptables-aggregate'],
  }
  file { "${firewall::snippet_dir}/${order}-${name}.v6":
    content => $ip6tables_content,
    source  => $ip6tables_source,
    notify  => Exec['ip6tables-aggregate'],
  }
}
