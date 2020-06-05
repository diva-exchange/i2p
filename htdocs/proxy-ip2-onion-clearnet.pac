   function FindProxyForURL(url, host)
   {
      if ( shExpMatch(host, "*.i2p$") ) {
        return "PROXY localhost:4444"
      }
      if ( shExpMatch(host, "*.onion$") ) {
        return "SOCKS localhost:9050"
      }
      return "DIRECT";
   }
