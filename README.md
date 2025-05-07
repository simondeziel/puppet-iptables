# Puppet iptables

Manages iptables rules (iptables/ip6tables) and make them persisent (load on boot).

## Requirements
* A distro with iptables-persistent or equivalent package.

This module invokes tools without specifying their full paths. This is
intentional and assumes your `manifests/site.pp` has something similar to:

```puppet
Exec {
  path      => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
  logoutput => 'on_failure',
}
```

## Usage

To install iptables and ip6tables rules from EPP templates:

```puppet
  class { 'iptables':
    iptables_content  => epp('foo/iptables/bar.ip46tables.epp', { 'ipver' => 'v4' }),
    ip6tables_content => epp('foo/iptables/bar.ip46tables.epp', { 'ipver' => 'v6' }),
  }
```

Where your `bar.ip46tables.epp` template could look something like this:

```
<%- | Enum['v4','v6'] $ipver |
# ip46tables
  $icmp        = $ipver ? {
    'v6'    => 'ipv6-icmp',
    default => 'icmp',
  }
  $trusted_ssh = lookup("my::ip-acls",Hash)[$ipver]['trusted-ssh']
-%>
# File managed by Puppet
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
# Connections in known state are allowed
-A INPUT -m conntrack --ctstate INVALID -j DROP
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# Loopback is trusted
-A INPUT -i lo -j ACCEPT
# Public HTTP(S)
-A INPUT -p tcp --dport  80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
# Restricted SSH access
<% $trusted_ssh.each |String $source| { -%>
-A INPUT -s <%= $source %> -p tcp --dport 22 -j ACCEPT
<% } -%>
# NRPE monitoring
<% if $ipver == 'v4' { -%>
-A INPUT -s foo.example.com -p tcp --dport 5666 -j ACCEPT
<% } else { -%>
# foo.example.com doesn't have an IPv6 address/AAAA record
<% } -%>
# ICMP allowed
-A INPUT -p <%= $icmp %> -j ACCEPT
COMMIT
```

In the above template, it is safe to use DNS names (`foo.example.com`) as they will be
resolved when loading the rules. The saved version will use the IP so it won't fail
to resolve when loading the ruleset during boot where DNS resolution may not be working
yet.

Rules are checked before loading into the kernel and saving to disk for later loading.
