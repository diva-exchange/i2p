   function FindProxyForURL(url, host)
   {
      if ( shExpMatch(host, "*.i2p$") ) {
        return "PROXY localhost:$PORT_HTTP_PROXY"
      }
      if ( shExpMatch(host, "*.onion$") ) {
        return "SOCKS localhost:$PORT_TOR"
      }
      return "DIRECT";
   }
