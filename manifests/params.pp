# @api private
# This class handles firewall params. Avoid modifying private classes.
class firewall::params {
  $use_snippets              = false
  $iptables_file             = '/etc/iptables/rules.v4'
  $iptables_in_file          = '/etc/iptables/rules.v4.in'
  $ip6tables_file            = '/etc/iptables/rules.v6'
  $ip6tables_in_file         = '/etc/iptables/rules.v6.in'
  $iptables_save             = '/sbin/iptables-save'
  $ip6tables_save            = '/sbin/ip6tables-save'
  $iptables_restore          = '/sbin/iptables-restore'
  $ip6tables_restore         = '/sbin/ip6tables-restore'
  $rules_dir                 = '/etc/iptables'
  $snippet_dir               = '/etc/iptables/snippet'
  $iptables_aggregated_file  = '/etc/iptables/rules.v4.aggregated'
  $ip6tables_aggregated_file = '/etc/iptables/rules.v6.aggregated'
  $group                     = 'sudo'
  $mode                      = '0640'
  $package_names             = ['iptables', 'iptables-persistent']
}
