use IO::Socket::INET;
use Time::HiRes qw(usleep);
use warnings;
use strict;
use Socket qw(IPPROTO_TCP);
use String::HexConvert ':all';
#doesn't really seem to autoflush ?

$|=1;
my $sock;
my $bla;


# this script unlocks the device if it's the default password

$sock = new IO::Socket::INET(
PeerHost => "10.2.0.200",
PeerPort => "1471",
Proto => "tcp"
) or die "error connecting: $!\n";
binmode($sock);
setsockopt($sock,IPPROTO_TCP,Socket::TCP_NODELAY(),1) || die "fuck me sideways: $!";

print "sending unlock prestuff\n";
print $sock hex_to_ascii("7B7B3C3CD1B90000010000000000010018246183AF6A3643ACE1A2BCE16BCC7AFE0200003E3E7D7D");
usleep(250000);

print "reading short response\n";
$sock->recv($bla,40);
print "response: $bla\n";

print "sending unlock prestuff 2\n";
print $sock hex_to_ascii("7B7B3C3CD1B9000001000000000001001340CBF93EFB95DD360A2BA75EE5EFF85B0300003E3E7D7D");
usleep(250000);

print "reading short response\n";
$sock->recv($bla,40);
print "response: $bla\n";

print "sending unlock prestuff 3\n";
print $sock hex_to_ascii("7B7B3C3CD1B900000100000000000100B62F311E0148CD931873ADB6E571813D");
usleep(250000);

print "sending unlock password\n";
print $sock hex_to_ascii("C065A5C1600C635B0E7E00B43A5618F26B0300003E3E7D7D");
#print $sock hex_to_ascii("C165A5C1600C635B0E7E00B43A5618F26B0300003E3E7D7D");
usleep(250000);


print "reading short response\n";
$sock->recv($bla,40);
print "response: $bla\n";
my @resp = split(//,$bla);

# TODO: implement a small response parser here to see if the password was correct
#print "byteanswer: " . int($resp[16]);
#if($resp[17] eq 0x13){ print "wrong pw :/\n";  }
# wrong pw: 7B 7B 3C 3C D1 B9 00 00 01 00 00 00 00 00 01 00 5B B0 1B A3 E5 7B 49 DF 3E 93 38 EB F4 64 AC 3C CC 03 00 00 3E 3E 7D 7D
# right pw: 7B 7B 3C 3C D1 B9 00 00 01 00 00 00 00 00 01 00 13 40 CB F9 3E FB 95 DD 36 0A 2B A7 5E E5 EF F8 5B 03 00 00 3E 3E 7D 7D



print "device unlocked\n";

$sock->close;
print "Socket closed\n";
