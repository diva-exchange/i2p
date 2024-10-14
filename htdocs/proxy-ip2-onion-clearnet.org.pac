   function FindProxyForURL(url, host)
   {
      if ( shExpMatch(host, "*.i2p$") ) {
        return "PROXY $IP_HOST:$PORT_HTTP_PROXY"
      }
      if ( shExpMatch(host, "*.onion$") ) {
        return "SOCKS $IP_HOST:$PORT_TOR"
      }
      return "DIRECT";
   }
