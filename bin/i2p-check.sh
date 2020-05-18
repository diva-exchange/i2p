#!/usr/bin/env bash

### WIP!!!!

#example: ./bin/i2p-check.sh 'http://i2pwiki.i2p'; 10

# curl --socks5 127.0.0.1:4444 -x socks5h://127.0.0.1:4444/ -s http://joajgazyztfssty4w2on5oaqksz6tqoxbduy553y34mf4byv6gpq.b32.i2p/search/?q=diva.i2p
# curl --socks5 127.0.0.1:4444 -x socks5h://127.0.0.1:4444/ -s http://zzz.i2p/

# http://zzz.i2p/

# http://zzz.i2p/topics/2215?page=1#p12665

for i in $(seq $2);
do
        SiTE="$1"
        STATUS=404
        TEST=$(curl -s -x "$(cat I2P | gshuf | head -n 1)" "$SiTE")
        echo "$TEST" | grep "<h3>Website Not Found in Addressbook</h3>" &> /dev/null
        STATUS=$(($STATUS+$?))
        STATUS2=1
        echo "$TEST" | grep "<h3>Website Unreachable</h3>"
        STATUS2=$(($STATUS2+$?))
        if [ "$STATUS2" -eq 1 ]
        then
                echo -e "> \e[91m 1 \e[0m"
        elif [ "STATUS" -eq 404 ]
        then
                echo -e "> \e[91m 404 \e[0m"
        else
                echo -e "> \e[92m 0 \e[0m"
        fi
done
