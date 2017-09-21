# @api private
# This class handles firewall packages. Avoid modifying private classes.
class firewall::install inherits firewall {
  ensure_packages($package_names)
}
