# Simple-Adblock-Tool
This script is responsible for creating a simple adblock mechanism. It rejects connections from specific domain names or IP (both IPV4 and IPV6) addresses using iptables and ip6tables.

## Prerequisites

The script must be run as root.

## Files

- `domainNames.txt`: This file should contain the domain names to be blocked.
- `IPAddresses.txt`: This file should contain the IP addresses to be blocked.
- `adblockRules`: This file will contain the saved iptables rules.
- `adblockRulesIPv6`: This file will contain the saved ip6tables rules.

These files should be created with these exact names.

## Usage

```bash
./adblock.sh [OPTION]
```

## Options

- `-domains`: Configure adblock rules based on the domain names of 'domainNames.txt' file.
- `-ips`: Configure adblock rules based on the IP addresses of 'IPAddresses.txt' file.
- `-save`: Save rules to 'adblockRules' file.
- `-load`: Load rules from 'adblockRules' file.
- `-list`: List current rules.
- `-reset`: Reset rules to default settings (i.e., accept all).
- `-help`: Display help and exit.

## Exit Status

Returns success unless an invalid option is given.

