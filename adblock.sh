#!/bin/bash
# You are NOT allowed to change the files' names!
domainNames="domainNames.txt"
IPAddresses="IPAddresses.txt"
adblockRules="adblockRules"

function adBlock() {
    if [ "$EUID" -ne 0 ];then
        printf "Please run as root.\n"
        exit 1
    fi
    if [ "$1" = "-domains"  ]; then
        # Configure adblock rules based on the domain names of $domainNames file.
       
        exec 3<$domainNames

        while read -r line; do
            ip_address=$(nslookup "$line" | sed -n '6p' | awk '/Address:/{print $2}')
            if [[ -z "$ip_address" ]]; then #check if the ip address is null
                echo "Unreachable site: $line"
            else
                echo "$ip_address" >> $IPAddresses #The ip of each domain name is saved in IPAddresses.txt
                iptables -C INPUT -s "$ip_address" -j REJECT || iptables -A INPUT -s "$ip_address" -j REJECT
            fi
            done < $domainNames
                        
        exec 3<&-

        true
            
    elif [ "$1" = "-ips"  ]; then
        # Configure adblock rules based on the IP addresses of $IPAddresses file.

        exec 3<$IPAddresses

        while read -r line; do

            iptables -C INPUT -s "$line" -j REJECT || iptables -A INPUT -s "$line" -j REJECT

        done < $IPAddresses
        
        exec 3<&-

        true
        
    elif [ "$1" = "-save"  ]; then
        # Save rules to $adblockRules file.
          
        iptables-save >> $adblockRules

        true
        
    elif [ "$1" = "-load"  ]; then
        # Load rules from $adblockRules file.
        
        iptables-restore < $adblockRules

        true
        
    elif [ "$1" = "-reset"  ]; then
        # Reset rules to default settings (i.e. accept all).
        
        iptables -F
        iptables -P INPUT ACCEPT
        iptables -P FORWARD ACCEPT
        iptables -P OUTPUT ACCEPT

        true
        
    elif [ "$1" = "-list"  ]; then
        # List current rules.
       
        iptables -L -v -n --line-numbers

        true
        
    elif [ "$1" = "-help"  ]; then
        printf "This script is responsible for creating a simple adblock mechanism. It rejects connections from specific domain names or IP addresses using iptables.\n\n"
        printf "Usage: $0  [OPTION]\n\n"
        printf "Options:\n\n"
        printf "  -domains\t  Configure adblock rules based on the domain names of '$domainNames' file.\n"
        printf "  -ips\t\t    Configure adblock rules based on the IP addresses of '$IPAddresses' file.\n"
        printf "  -save\t\t   Save rules to '$adblockRules' file.\n"
        printf "  -load\t\t   Load rules from '$adblockRules' file.\n"
        printf "  -list\t\t   List current rules.\n"
        printf "  -reset\t    Reset rules to default settings (i.e. accept all).\n"
        printf "  -help\t\t   Display this help and exit.\n"
        exit 0
    else
        printf "Wrong argument. Exiting...\n"
        exit 1
    fi
}

adBlock $1
exit 0