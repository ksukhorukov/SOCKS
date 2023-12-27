# SOCKS5 PROXY MANAGEMENT SCRIPT

SOCKS is an Internet protocol that exchanges network packets between a client and server through a proxy server. 

SOCKS5 optionally provides authentication so only authorized users may access a server. 

Practically, a SOCKS server proxies TCP connections to an arbitrary IP address, and provides a means for UDP packets to be forwarded.

SOCKS performs at Layer 5 of the OSI model (the session layer, an intermediate layer between the presentation layer and the transport layer). 

A SOCKS server accepts incoming client connection on TCP port 1080, as defined in RFC 1928.

# REQUIREMENTS

 - Debian or Ubuntu with kernel version >= 5.10.0
 - OpenSSH server 9.* or higher

# SERVER INSTALL AND SETUP

It will be installed automatically when you trigger the start from the first time, but you can launch installation procedure manually 
even in advance using this command:

```
./socks.sh install
```

Then you have to run your server:

```
./socks.sh start
```

By default the script use 5555 and you can check the status of the server with the following command:

```
./socks.sh status
```

Command to stop the server:

```
./socks.sh stop
```

If you want to remind yourself available commands, just run the script without any parameters:

```
user@air socks % ./socks.sh 
USAGE: ./socks.sh [ install | start | stop | status ]
```

# HOW TO USE YOUR BRAND NEW SOCKS5 SERVER

In general case you have to configure your Internet to use SOCKS5 proxy address and port. 

The default port is 5555

For example, in Google Chrome, you can go to Settings > Advanced > System and click the checkbox next to 
"Use a proxy server for your LAN." Then, enter the address and port of your SOCKS5 proxy server.

How to use it MacOS?

If you want to use SOCKS5 for everything on your Mac, you can simply configure it in Network Preferences. 
Open Network Preferences, click on Advanced and then Proxies. and enter your username and password. 
Click on OK and then Apply and that's it, your Mac will now use our SOCKS5 server to connect to the internet.

# VERIFY THAT YOUR IP WAS HIDDEN

You can go to some site that determines your location for instance this one:

[https://whatismyipaddress.com](https://whatismyipaddress.com)

The location of you should be termined as the location of your SOCKS5 server IP address and your 
IP address should be the same as the ip IP address of the server where you have deployed the script

For instance if you are located in the US and your server is in Europe, the aforementioned site will say
that you are located in Europe if the script has been deployed correctly.

# DEBUGGING

There are several verbosity levels for debugging purposes.

Silent mode turned on by dedault but you can make this script more verbose for instance for debugging purposes:

```
export VERBOSE=1
```

In order to make it silent again just unset the verbose variable:

```
unset VERBOSE
```

or actualy, this command will be just enough fore the one-time usage:

```
VERBOSE=1 ./socks.sh start
```

## [EOF]
