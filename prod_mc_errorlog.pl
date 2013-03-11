#This is a listener code which connects to a multicast address and captures multicast messages.


#!/usr/bin/perl

use IO::Socket;
use Sys::Hostname;

# sets an auto-flush for both STDOUT and STDERR
STDOUT->autoflush(1);
STDERR->autoflush(1);

# defined here because of syntax errors in netinet/in.ph.
local $IPPROTO_IP = 0;
local $IP_ADD_MEMBERSHIP = 0x23;
local $IP_DROP_MEMBERSHIP = 0x14;


local $group = shift;
defined($group) || ($group = '<group>');

local $port = shift;
defined($port) || ($port = '<port>');


# create the socket.
local $proto = getprotobyname('udp');
socket(S, AF_INET, SOCK_DGRAM, $proto) || die "socket: $!";

# join the multicast group.
local $mreq = pack('C8', split(/\./, $group.".0.0.0.0"));
setsockopt(S, $IPPROTO_IP, $IP_ADD_MEMBERSHIP, $mreq) || die "setsockopt: $!";

# allow multiple listeners for the socket.
setsockopt(S, SOL_SOCKET, SO_REUSEADDR, 1) || die "setsockopt: $!";

# bind to the address.
local $iaddr = pack('C4', split(/\./, '0.0.0.0'));
local $laddr = pack('S n a4 x8', AF_INET, $port, $iaddr);
bind(S, $laddr) || die "bind: $!";

local $msg = '';

while (1){
    recv(S, $msg, 2056, 0) || die "recv: $!";
    if ($msg =~ "MSG1" || $msg =~ "MSG2" || $msg =~ "TIMEOUT MSG" || $msg =~ "ERROR MSG" )
    {
            print "WHOLE MSG: $msg\n";
    }
}
