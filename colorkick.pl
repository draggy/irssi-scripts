use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
        authors => "draggy",
        name => "colorkick",
        description => "Kicks users who use color in the specified channels",
        changed => "11.16.2009"
);

my $kickmessage = "No Colours!!!";

my $servertag = "servername";

my @channels = ("#channel1", "#channel2");

my $match = "\\cC\\d+";


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
				if ($msg =~ $match) {
					Irssi::print "Kicking $nick->{nick} for using colors.";
					kick($server, $channel, $nick->{nick}, $kickmessage);
				}
			}
		}
	}
}

Irssi::signal_add("message public", \&getdata);
