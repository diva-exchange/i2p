#!/usr/bin/env bash

#source: https://tor.stackexchange.com/questions/12678/how-to-check-if-tor-is-working-and-debug-the-problem-on-cli
curl --socks5 127.0.0.1:9050 -x socks5h://127.0.0.1:9050/ -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs
