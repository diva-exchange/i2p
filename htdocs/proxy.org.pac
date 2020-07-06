   function FindProxyForURL(url, host)
   {
      if ( shExpMatch(host, "*.i2p$") ) {
        return "PROXY localhost:$PORT_HTTP_PROXY"
      }
      return "SOCKS localhost:$PORT_TOR";
   }
