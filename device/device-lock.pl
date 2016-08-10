use IO::Socket::INET;
use Time::HiRes qw(usleep);
use warnings;
use strict;
use Socket qw(IPPROTO_TCP);
#doesn't really seem to autoflush ?
$|=1;
my $sock;


# this script puts the device in locked mode

$sock = new IO::Socket::INET(
PeerHost => "172.16.0.10",
PeerPort => "1471",
Proto => "tcp"
) or die "error connecting: $!\n";
binmode($sock);
setsockopt($sock,IPPROTO_TCP,Socket::TCP_NODELAY(),1) || die "fuck me sideways: $!";
my $pre1 = "\x7B\x7B\x3C\x3C\xD1\xB9\x00\x00\x01\x00\x00\x00\x00\x00\x01\x00\xC3\x4D\x83\x18\x52\x95\x4B\x20\xCA\x23\x3B\x0A\x0B\xDF\x47\x2E\x5A\x03\x00\x00\x3E\x3E\x7D\x7D";

my $pre2 = "\x7B\x7B\x3C\x3C\xD1\xB9\x00\x00\x01\x00\x00\x00\x00\x00\x01\x00\x30\x40\x99\x5C\x0F\xB5\x9D\xEE\x8A\x8E\x35\x19\xD0\x32\x53\xEB\x0B\x03\x00\x00\x3E\x3E\x7D\x7D";

print "sending device lock packetz\n";
print $sock $pre1; usleep(250000);
print $sock $pre2; usleep(250000);

print "reading short response\n";
my $bla;
$sock->recv($bla,40);
print "response: $bla\n";

print "device locked\n";

$sock->close;
print "Socket closed\n";
