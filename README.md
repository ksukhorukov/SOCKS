# SOCKS

## SOCKS5 Proxy Server Management Script

# Requirements

Debian or Ubuntu with kernel version >= 5.10.0

# Usage 

USAGE: ./socks.sh [ install | start | stop | status ]

# Verbosity And Silent Modes

Silent mode turned on by dedault but you can make this script more verbose:

```
export VERBOSE=1
```

In order to make it silent again:

```
unset VERBOSE
```

or actualy, this command will be just enough fore the one-time usage:

```
VERBOSE=1 ./socks.sh start
```

## [EOF]
