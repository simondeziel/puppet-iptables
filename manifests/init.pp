#
# Class: iptables
#
# Deploy commented ruleset in /etc/iptables/rules.v[46].in
# and save working ones in /etc/iptables/rules.v[46]
#
class iptables (
  Boolean          $use_snippets      = false,
  Stdlib::UnixPath $rules_dir         = '/etc/iptables',
  Optional[String] $iptables_content  = undef,
  Optional[String] $iptables_source   = undef,
  Stdlib::UnixPath $iptables_file     = "${rules_dir}/rules.v4",
  Optional[String] $ip6tables_content = undef,
  Optional[String] $ip6tables_source  = undef,
  Stdlib::UnixPath $ip6tables_file    = "${rules_dir}/rules.v6",
  String           $group             = 'sudo',
  String           $mode              = '0640',
  Stdlib::UnixPath $snippet_dir       = "${rules_dir}/snippet",
  Array[String]    $package_names     = ['iptables', 'iptables-persistent'],
  String           $iptables_save     = 'iptables-save',
  String           $ip6tables_save    = 'ip6tables-save',
  String           $iptables_restore  = 'iptables-restore',
  String           $ip6tables_restore = 'ip6tables-restore',
) {

  # derive some variables based on provided params
  $iptables_in_file          = "${iptables_file}.in"
  $ip6tables_in_file         = "${ip6tables_file}.in"
  $iptables_aggregated_file  = "${iptables_file}.aggregated"
  $ip6tables_aggregated_file = "${ip6tables_file}.aggregated"

  contain iptables::install
  contain iptables::config
  contain iptables::exec

  Class['::iptables::install']
  -> Class['::iptables::config']
  -> Class['::iptables::exec']
}
