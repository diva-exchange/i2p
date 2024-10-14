   function FindProxyForURL(url, host)
   {
      if ( shExpMatch(host, "*.i2p$") ) {
        return "PROXY $IP_HOST:$PORT_HTTP_PROXY"
      }
      return "SOCKS $IP_HOST:$PORT_TOR";
   }
