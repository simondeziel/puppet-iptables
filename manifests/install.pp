# @api private
# This class handles iptables packages. Avoid modifying private classes.
class iptables::install inherits iptables {
  ensure_packages($package_names)
}
