#!/bin/bash
domain=$1
if [ "$domain" = "" ]; then
  echo "Need domain"
  exit
fi
nslookup $domain
whois $domain
traceroute $domain
