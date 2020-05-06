# Private Browsing Experience
Enjoy a smooth private browsing experience both on the clearnet (like https://diva.exchange) and the darknet (onion and i2p sites, like http://diva.i2p). Use your favourite browser (like Firefox). Hence it should be suitable for beginners.

Please note: this setup is only a first - yet necessary - step to protect your privacy. You need to change your behaviour to protect your online privacy (like: use NoScript, AdBlock). Also fingerprinting (a hash of your online footprint) and obviously login data is a threat. On your systems and mobile phones there are plenty of applications running which will leak your private data. This project helps you only with browsing.

However: we hope this project helps you to get started.

## Get started
Docker (https://www.docker.com/get-started) must be available on your system. 

To get your new private browsing experience up and running:
1. Pull the docker image (in a shell/powershell): `docker pull divax/tor-i2p`
2. Run the Docker container
3. Adapt your browser proxy settings

### How to Run the Docker Container
 
#### On Linux, OSX and Windows
Run the following command in a shell (powershell on Windows):

`docker run --mount src=i2pd,dst=/home/i2pd -p 7070:7070 -p 4444:4444 -p 4445:4445 -p 9050:9050 -p 8080:8080 -d --name i2pd divax/i2p`

### How to Adapt the Proxy Settings of Your Browser
Open your favourite browser, like Firefox. Open the settings. Search for "proxy". Then enable "Automatic proxy configuration URL" and set it to "http://localhost:8080/proxy.pac".

This proxy configuration (see source code below for details) uses your new docker container to route all your browser traffic through either I2P or TOR. If you now browse the clearnet (like https://diva.exchange) you'll be using automatically TOR.    

## Build from Source
### On Linux
To rebuild all the I2Pd binaries from source execute  `build.sh`

## Source Code
Its GPLv3 licensed and the source code is available here:
https://codeberg.org/diva.exchange/i2p

The source code of the underlying I2Pd project is found here: https://github.com/PurpleI2P/i2pd
