   function FindProxyForURL(url, host)
   {
      if ( shExpMatch(host, "*.i2p$") ) {
        return "PROXY localhost:4444"
      }
      return "SOCKS localhost:4446";
   }
