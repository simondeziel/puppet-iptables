#
# Class: iptables
#
# Deploy commented ruleset in /etc/iptables/rules.v[46].in
# and save working ones in /etc/iptables/rules.v[46]
#
class iptables (
  Boolean $use_snippets                   = $iptables::params::use_snippets,
  Optional[String] $iptables_content      = undef,
  Optional[String] $iptables_source       = undef,
  Stdlib::AbsolutePath $iptables_file     = $iptables::params::iptables_file,
  Stdlib::AbsolutePath $iptables_in_file  = $iptables::params::iptables_in_file,
  Optional[String] $ip6tables_content     = undef,
  Optional[String] $ip6tables_source      = undef,
  Stdlib::AbsolutePath $ip6tables_file    = $iptables::params::ip6tables_file,
  Stdlib::AbsolutePath $ip6tables_in_file = $iptables::params::ip6tables_in_file,
  String $group                           = $iptables::params::group,
  String $mode                            = $iptables::params::mode,
  Stdlib::AbsolutePath $snippet_dir       = $iptables::params::snippet_dir,
  Array[String] $package_names            = $iptables::params::package_names,
  Stdlib::AbsolutePath $iptables_save     = $iptables::params::iptables_save,
  Stdlib::AbsolutePath $ip6tables_save    = $iptables::params::ip6tables_save,
  Stdlib::AbsolutePath $iptables_restore  = $iptables::params::iptables_restore,
  Stdlib::AbsolutePath $ip6tables_restore = $iptables::params::ip6tables_restore,
) inherits iptables::params {
  contain iptables::install
  contain iptables::config
  contain iptables::exec

  Class['::iptables::install']
  -> Class['::iptables::config']
  -> Class['::iptables::exec']
}
