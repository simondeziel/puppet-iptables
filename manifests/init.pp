#
# Class: firewall
#
# Deploy commented ruleset in /etc/iptables/rules.v[46].in
# and save working ones in /etc/iptables/rules.v[46]
#
class firewall (
  Boolean $use_snippets                   = $firewall::params::user_snippets,
  Optional[String] $iptables_content      = undef,
  Optional[String] $iptables_source       = undef,
  Stdlib::AbsolutePath $iptables_file     = $firewall::params::iptables_file,
  Stdlib::AbsolutePath $iptables_in_file  = $firewall::params::iptables_in_file,
  Optional[String] $ip6tables_content     = undef,
  Optional[String] $ip6tables_source      = undef,
  Stdlib::AbsolutePath $ip6tables_file    = $firewall::params::ip6tables_file,
  Stdlib::AbsolutePath $ip6tables_in_file = $firewall::params::ip6tables_in_file,
  String $group                           = $firewall::params::group,
  String $mode                            = $firewall::params::mode,
  Stdlib::AbsolutePath $snippet_dir       = $firewall::params::snippet_dir,
  Array[String] $package_names            = $firewall::params::package_names,
  Stdlib::AbsolutePath $iptables_save     = $firewall::params::iptables_save,
  Stdlib::AbsolutePath $ip6tables_save    = $firewall::params::ip6tables_save,
  Stdlib::AbsolutePath $iptables_restore  = $firewall::params::iptables_restore,
  Stdlib::AbsolutePath $ip6tables_restore = $firewall::params::ip6tables_restore,
) inherits firewall::params {
  contain firewall::install
  contain firewall::config
  contain firewall::exec

  Class['::firewall::install']
  -> Class['::firewall::config']
  -> Class['::firewall::exec']
}
