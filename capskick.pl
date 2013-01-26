use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
        authors => "draggy",
        name => "userkick",
        description => "Kicks users who use caps in the specified channels",
        changed => "11.16.2009"
);

my $kickmessage = "NO CAPS!!!";

my $servertag = "servername";

my @channels = ("#channel1", "#channel2");

my $match = "(?:(?:(?:[\.|\,|\?|\!|\@|\%|\*|\(|\)|\[|\)|\{|\}|\-|\\w]*[A-Z][\.|\,|\?|\!|\@|\%|\*|\(|\)|\[|\)|\{|\}|\-|\\w]*){3})(?:\\s|\^|\$).*){3}";

my $limit = 80;

sub kick {
        my ($server, $channel, $nick, $message) = @_;
	$server->command("kick $channel $nick $message" ) if ( $server ); 
}

sub getdata{
	my ($server,$msg,$user,$address,$sourcechannel) = @_;
	my $chan = $server->channel_find($sourcechannel);	
	my $nick = $chan->nick_find($user);

	if ($server->{ tag } eq $servertag && !$nick->{op} && !$nick->{voice} && !$nick->{halfop}) {
		for my $channel (@channels) {	
			if ($chan->{name} eq $channel) {
				
				if (length($msg) > $limit) {
			                $msg = substr($msg, 0, $limit);
			        }

				if ($msg =~ $match) {
					Irssi::print "Kicking $nick->{nick} for typing in CAPS.";
					kick($server, $channel, $nick->{nick}, $kickmessage);
				}
			}
		}
	}
}

Irssi::signal_add("message public", \&getdata);
