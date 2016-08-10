use IO::Socket::INET;
use Time::HiRes qw(usleep);
use warnings;
use strict;
use Socket qw(IPPROTO_TCP);
use String::HexConvert ':all';
#doesn't really seem to autoflush ?
# this script sets pw for user "admin" to something else
# requires the socat bridge to be running

$|=1;
my $sock; my $bla;

$sock = new IO::Socket::INET( PeerHost => "127.0.0.1",PeerPort => "1480",Proto => "tcp") or die "error connecting: $!\n";
binmode($sock); setsockopt($sock,IPPROTO_TCP,Socket::TCP_NODELAY(),1) || die "fuck me sideways: $!";

sub send{ my $data = $_[0]; print $sock hex_to_ascii($data); usleep(250000); }
sub getshort{ print "reading short response\n";$sock->recv($bla,40);usleep(250000);print "response: $bla\n";}
sub getvaried{ print "reading varied response\n";$sock->recv($bla,int($_[0]));print "response: $bla\n"; }


print "sending 15\n";
&send("7B7B3C3C00000000000000000000010000000000130200000000000000000000840100003E3E7D7D");

print "sending 16\n";
&send("7B7B3C3C000000000000000000000100000000006B1000001500000000000000FF0100003E3E7D7D");
#getshort();

print "sending 17\n";
&send("7B7B3C3C0000000000000000000001000000000013020000B400000000000000380200003E3E7D7D");

print "sending 18\n";
&send("7B7B3C3C00000000000000000000010000000000940100000000000000000000040200003E3E7D7D");

print "sending 19\n";
&send("7B7B3C3C000000000000000000000100B40000009401000001000000B4000000");

print "sending 20\n";
&send("00000000A80000000000000061646D696E00000000000000000000000000000000000000000000000000000030414445393141444632363445303041434341383041383736313837433432390000000000000000000000000000000000000000000000000000000000000000010000000000000041646D696E6973747261746F72000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");

print "sending 21\n";
&send("C81200003E3E7D7D");
getshort();

$sock->close;
print "Socket closed\n";
