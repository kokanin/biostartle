# socat -v -x TCP4-LISTEN:1480 openssl-connect:192.168.116.157:1480,verify=0,cert=../../certs/bioadmin_client.crt,key=../../certs/bioadmin_client.key 


use IO::Socket::INET;
use Time::HiRes qw(usleep);
use warnings;
use strict;
use Socket qw(IPPROTO_TCP);
use String::HexConvert ':all';
#doesn't really seem to autoflush ?
# this script adds a new admin to the biostar server
# requires the socat bridge to be running

$|=1;
my $sock; my $bla;

$sock = new IO::Socket::INET( PeerHost => "127.0.0.1",PeerPort => "1480",Proto => "tcp") or die "error connecting: $!\n";
binmode($sock); setsockopt($sock,IPPROTO_TCP,Socket::TCP_NODELAY(),1) || die "fuck me sideways: $!";

sub send{ my $data = $_[0]; print $sock hex_to_ascii($data); usleep(250000); }
sub getshort{ print "reading short response\n";$sock->recv($bla,40);usleep(250000);print "response: $bla\n";}
sub getvaried{ print "reading varied response\n";$sock->recv($bla,int($_[0]));print "response: $bla\n"; }


print "sending 27\n";
&send("7B7B3C3C00000000000000000000010000000000130200000000000000000000840100003E3E7D7D");

print "sending 28\n";
&send("7B7B3C3C000000000000000000000100000000006B1000001500000000000000FF0100003E3E7D7D");
#getshort();

print "sending 29\n";
&send("7B7B3C3C0000000000000000000001000000000013020000B400000000000000380200003E3E7D7D");

print "sending 30\n";
&send("7B7B3C3C00000000000000000000010000000000300100000000000000000000A00100003E3E7D7D");

print "sending 31\n";
&send("7B7B3C3C000000000000000000000100B40000003001000001000000B4000000");

print "sending 32\n";
&send("00000000A8000000000000006B6E75640000000000000000000000000000000000000000000000000000000036304245394138383832453835324338313633383235393531334439453031320000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");

print "sending 33\n";
&send("640C00003E3E7D7D");
getshort();

$sock->close;
print "done\n";
