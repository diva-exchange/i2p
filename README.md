# I2P - For Everyone

Two flavours are available:
* Entry-level experience: I2P, Tor and a proxy to enable everyone to get started using the i2p and onion network. It's tagged as "i2p-tor-proxy". 
* For advanced users: I2P only version - very lean. It's tagged as "latest".

The solutions are deployed as docker image.

If you are looking for an entry-level experience, focused on browsing the network: use the docker image tagged as "i2p-tor-proxy". Read the "Get Started" below.   

If you are experienced and looking for an I2P-only container - go for the docker imaged tagged as "latest". You get the latest stable i2pd (C++ version) release. Lean & fast.

A great tutorial, including "How to setup your system", is found here: [Introduction to “I2P”](https://www.diva.exchange/en/privacy/introduction-to-i2p-your-own-internet-secure-private-and-free/).

## Entry-Level Experience - I2P & Onion: Private Browsing
Enjoy a smooth and private browsing experience on multiple networks (like https://diva.exchange or also onion and i2p sites like http://diva.i2p). Use your favourite browser (like Firefox). Hence it should be suitable for beginners.

Please note: an entry-level setup is only a first - yet necessary - step to protect your privacy. You need to change your behaviour to protect your online privacy (like: use NoScript, AdBlock). Also fingerprinting (a hash of your online footprint) and obviously login data is threatening your privacy. This project helps you to get started with private browsing.

## DNS-over-TLS
All DNS queries of this docker container are resolved using DNS-over-TLS (DoT). DoT makes it difficult to spy out DNS queries.

## Get Started
Docker (https://www.docker.com/get-started) must be available on your system. 

To get your new private browsing experience up and running:
1. Pull the docker image (in a shell/powershell): `docker pull divax/i2p:i2p-tor-proxy` or `docker pull divax/i2p:latest` 
2. Run the Docker container
3. Adapt your browser proxy settings

As said, this tutorial might be helpful: [Introduction to “I2P”](https://www.diva.exchange/en/privacy/introduction-to-i2p-your-own-internet-secure-private-and-free/).

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

This proxy configuration (see source code below for details) uses your new docker container to route all your browser traffic through either I2P or Tor. If you now browse the clearnet (like https://diva.exchange) you'll be using automatically Tor.

### Advanced: Configuration
The docker container is exposing an http and a socks proxy. By default, the container exposes the http proxy on port 4444 and the socks proxy on port 4445. 

The configuration files for I2P are found within the folder `./conf`, whereas `i2pd.org.conf` contains the main I2P configuration and `tunnels.org.conf` contains the tunnel configuration. The configuration files for DNS-over-TLS are found within the folder `./network`: `resolv.conf` is containing nameserver information and `stubby.yml` contains the configuration for DNS-over-TLS. The Tor configuration file is found within the folder `./network`: `torrc` configures the behaviour of the Tor service.

The configuration of a container might be influenced with environment variables: DISABLE_TUNNELS, PORT_BACKEND, PORT_EXPOSED and IP_BRIDGE.

If DISABLE_TUNNELS is set to 1, then the container will be started without a tunnels configuration. Defaults to 0 and therefore tunnels are enabled by default.

PORT_BACKEND points to a listening backend service on the interface set by IP_BRIDGE. IP_BRIDGE points by default to the docker host interface. Example: if a HTTP server is running on port 8080 on the docker host, PORT_BACKEND would be set to 8080 and the HTTP service would be exposed to I2P. The default value of PORT_BACKEND is set to 3902.

PORT_EXPOSED defines the port exposed to the I2P network. By default it is the same as PORT_BACKEND.

Some examples on how to use environment variables:

`docker run --env DISABLE_TUNNELS=1 -p 7070:7070 -p 4444:4444 -p 4445:4445 -d --name i2pd divax/i2p:latest`

`docker run --env PORT_BACKEND=8080 --env PORT_EXPOSED=80 -p 7070:7070 -p 4444:4444 -p 4445:4445 -d --name i2pd divax/i2p:latest`

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
