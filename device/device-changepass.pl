use IO::Socket::INET;
use Time::HiRes qw(usleep);
use warnings;
use strict;
use Socket qw(IPPROTO_TCP);
use String::HexConvert ':all';
#doesn't really seem to autoflush ?
# this script changes the password on the device to AAAAAAAAAAAAAAAA if it has the default password (16 nulls)

$|=1;
my $sock; my $bla;

$sock = new IO::Socket::INET( PeerHost => "172.16.0.10",PeerPort => "1471",Proto => "tcp") or die "error connecting: $!\n";
binmode($sock); setsockopt($sock,IPPROTO_TCP,Socket::TCP_NODELAY(),1) || die "fuck me sideways: $!";

sub send{ my $data = $_[0]; print $sock hex_to_ascii($data); usleep(250000); }
sub getshort{ print "reading short response\n";$sock->recv($bla,40);usleep(250000);print "response: $bla\n";}
sub getvaried{ print "reading varied response\n";$sock->recv($bla,int($_[0]));print "response: $bla\n"; }


print "sending 1\n";
&send("7B7B3C3CD1B90000010000000000010018246183AF6A3643ACE1A2BCE16BCC7AFE0200003E3E7D7D");
getshort(); # is that the old password, so the client can check?

print "sending 3\n";
&send("7B7B3C3CD1B900000100000000000100A5E6E791C3E617F3AEBFB914DF9231AD050300003E3E7D7D");
getshort();

print "sending 5\n";
&send("7B7B3C3CD1B900000100000000000100752346E6FF2E08784A9AD0D172F507A6");
#getshort();

print "sending 6\n";
&send("C065A5C1600C635B0E7E00B43A5618F256F3849F8137F886E435A66B66816BDCD90B00003E3E7D7D");
getshort();

$sock->close;
print "Socket closed\n";
