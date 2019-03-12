# @api private
# This class handles iptables packages. Avoid modifying private classes.
class iptables::install {
  ensure_packages($iptables::package_names)
}
