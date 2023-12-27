# SOCKS

## SOCKS5 Proxy Server Management Script

# DESCRIPTION



# REQUIREMENTS

 - Debian or Ubuntu with kernel version >= 5.10.0
 - OpenSSH server 9.* or higher

# INSTALL

It will be installed automatically, but you can trigger installation procedure manually 
using this command:

```
./socks.sh install
```

# USAGE

```
./socks.sh [ install | start | stop | status ]
```

# VERBOSE AND SILENT MODES

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
