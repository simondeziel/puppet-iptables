# @api private
# This class handles firewall params. Avoid modifying private classes.
class firewall::params {
  $iptables_filename     = 'rules.v4'
  $iptables_in_filename  = 'rules.v4.in'
  $ip6tables_filename    = 'rules.v6'
  $ip6tables_in_filename = 'rules.v6.in'
  $rules_dir             = '/etc/iptables'
  $group                 = 'sudo'
  $mode                  = '0640'
  $package_names         = ['iptables','iptables-persistent']
}
