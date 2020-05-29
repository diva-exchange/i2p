# I2P - ready to use

Two flavours of this docker image are available:
* I2P only version - very lean. It's tagged as "latest".
* I2P, Tor and a proxy to enable everyone to get started using the i2p and onion network. It's tagged as "i2p-tor-proxy". 

If you are an I2P pro - go for the imaged tagged as "latest". You get the latest stable i2pd (C++ version) release. Lean & fast.

If you are looking for an entry-level experience, focused on browsing the network: use the image tagged as "i2p-tor-proxy".  

## Entry level - I2P & Onion: Private Browsing Experience
Enjoy a smooth private browsing experience both on the clearnet (like https://diva.exchange) and the darknet (onion and i2p sites/eepsites, like http://diva.i2p). Use your favourite browser (like Firefox). Hence it should be suitable for beginners.

Please note: this entry-level setup is only a first - yet necessary - step to protect your privacy. You need to change your behaviour to protect your online privacy (like: use NoScript, AdBlock). Also fingerprinting (a hash of your online footprint) and obviously login data is a threat. On your systems and mobile phones there are plenty of applications running which will leak your private data. This project helps you with browsing.

## Get started
Docker (https://www.docker.com/get-started) must be available on your system. 

To get your new private browsing experience up and running:
1. Pull the docker image (in a shell/powershell): `docker pull divax/i2p:i2p-tor-proxy` or `docker pull divax/i2p:latest` 
2. Run the Docker container
3. Adapt your browser proxy settings

### How to Run the Docker Container
 
#### On Linux, OSX and Windows
Run the following command in a shell (powershell on Windows):

`docker run -p 7070:7070 -p 4444:4444 -p 4445:4445 -d --name i2pd divax/i2p:latest`

### How to Adapt the Proxy Settings of Your Browser
Open your favourite browser, like Firefox. Open the settings. Search for "proxy". Then enable "Automatic proxy configuration URL" and set it to "http://localhost:8080/proxy.pac".

This proxy configuration (see source code below for details) uses your new docker container to route all your browser traffic through either I2P or TOR. If you now browse the clearnet (like https://diva.exchange) you'll be using automatically TOR.    

## Build from Source
### On Linux
To rebuild all the I2Pd binaries from source execute  `./bin/build.sh`

## Source Code
Its GPLv3 licensed and the source code is available here:
https://codeberg.org/diva.exchange/i2p

The source code of the underlying I2Pd project is found here: https://github.com/PurpleI2P/i2pd
