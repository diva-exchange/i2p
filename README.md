# I2P - ready to use

Two flavours are available:
* Entry-level experience: I2P, Tor and a proxy to enable everyone to get started using the i2p and onion network. It's tagged as "i2p-tor-proxy". 
* For advanced users: I2P only version - very lean. It's tagged as "latest".

The solutions are deployed as docker image.

If you are looking for an entry-level experience, focused on browsing the network: use the docker image tagged as "i2p-tor-proxy". Read the "Get Started" below.   

If you are an I2P pro - go for the docker imaged tagged as "latest". You get the latest stable i2pd (C++ version) release. Lean & fast.

## Entry-Level Experience - I2P & Onion: Private Browsing
Enjoy a smooth private browsing experience both on the clearnet (like https://diva.exchange) and the darknet (onion and i2p sites/eepsites, like http://diva.i2p). Use your favourite browser (like Firefox). Hence it should be suitable for beginners.

Please note: an entry-level setup is only a first - yet necessary - step to protect your privacy. You need to change your behaviour to protect your online privacy (like: use NoScript, AdBlock). Also fingerprinting (a hash of your online footprint) and obviously login data is a threat. On your systems and mobile phones there are plenty of applications leaking your private data. This project helps you with browsing.

## DNS-over-TLS
All DNS queries of this docker container are resolved using DNS-over-TLS (DoT). DoT makes it difficult to spy out DNS queries.

## Get Started
Docker (https://www.docker.com/get-started) must be available on your system. 

To get your new private browsing experience up and running:
1. Pull the docker image (in a shell/powershell): `docker pull divax/i2p:i2p-tor-proxy` or `docker pull divax/i2p:latest` 
2. Run the Docker container
3. Adapt your browser proxy settings

### How to Run the Docker Container
 
#### On Linux, OSX and Windows
Run one of the following command in a shell (powershell on Windows).

To run the I2P/TOR/proxy only (entry-level):
`docker run -p 7070:7070 -p 4444:4444 -p 4445:4445 -p 9050:9050 -p 8080:8080 -d --name i2pd divax/i2p:i2p-tor-proxy`

To run I2P only (advanced):
`docker run -p 7070:7070 -p 4444:4444 -p 4445:4445 -d --name i2pd divax/i2p:latest`

### Check the Status of your Container
Check your now-running docker container with `docker ps -a` (within your shell/powershell) and look for the container "i2pd".

### Entry-Level: How to Adapt the Proxy Settings of Your Browser
Open your favourite browser, like Firefox. Open the settings. Search for "proxy". Then enable "Automatic proxy configuration URL" and set it to "http://localhost:8080/proxy.pac".

This proxy configuration (see source code below for details) uses your new docker container to route all your browser traffic through either I2P or TOR. If you now browse the clearnet (like https://diva.exchange) you'll be using automatically Tor.

### Advanced: Configuration
The docker container is exposing an http and a socks proxy. By default, the container exposes the http proxy on port 4444 and the socks proxy on port 4445. 

The configuration files for I2P are found within `./conf`: `i2pd.conf` and `tunnels.conf`). The configuration files for DNS-over-TLS are found within `./network`: `resolv.conf` and `stubby.yml`. Also the Tor configuration file is found within `./network`: `torrc`.

## Build from Source
### On Linux
To rebuild the docker image and all the contained binaries from source, execute  `./bin/build.sh`

## Source Code
GPLv3 licensed and the source code is available here:
https://codeberg.org/diva.exchange/i2p

The source code of the underlying "I2Pd" project is found here: https://github.com/PurpleI2P/i2pd

The source code of the included DNS-over-TLS project, "stubby", is found here: https://github.com/getdnsapi/stubby

## Contact the Developers
Talk to us on Telegram https://t.me/diva_exchange_chat_de (English or German).
