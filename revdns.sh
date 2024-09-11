#!/bin/bash

ipv4='(\b25[0-5]|\b2[0-4][0-9]|\b[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}'
ipv6='(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'

Help()
{
    echo
    echo "[i] Description: Reverse DNS for single IP address or IP addresses list."
    echo "[i] Usage: ./revdns.sh [Options] use -l for a list of IP in a file, -i for a single IP address"
    echo "[i] Example: ./revdns.sh -l ../ip_list.txt"
    echo
}

Head()
{
    echo
    echo  " __ _     _|__  _     _ |_ "
    echo  " | (/_\_/(_|| |_>  o _> | |"
    echo
}

if [ $# -gt 2 ]; then
    Help
    exit 1
fi

case $1 in
    --list | -l)
        Head
        echo
        while read ip; do
            if [[ $ip =~ $ipv4 || $ip =~ $ipv6 ]]; then
                hostname=`host $ip`
                if [ $? -eq 0 ]; then
                    if [[ $(host $ip) != *NXDOMAIN* ]]; then
                        echo $hostname | awk '{ print $NF }'
                    else
                        echo "$(tput setaf 1)This is not a public IP address!$(tput sgr0)"
                    fi
                fi
            else
                echo "$(tput setaf 1)IP address is invalid!$(tput sgr0)"
            fi
        done < $2
        ;;
    --ip | -i)
        Head
        echo
        if [[ $2 =~ $ipv4 || $2 =~ $ipv6 ]]; then
            if [[ $(host $2) != *NXDOMAIN* ]]; then
                echo `host $2 | awk '{ print $NF }'`
            else
                echo "$(tput setaf 1)This is not a public IP address!$(tput sgr0)"
            fi
        else
            echo "$(tput setaf 1)IP address is invalid!$(tput sgr0)"
            Help
            exit 1
        fi
        ;;
    *)
        Head
        Help
        ;;
esac
