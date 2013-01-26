use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
        authors => "draggy",
        name => "userkick",
        description => "Kicks and messages users who use the trigger",
        changed => "11.16.2009"
);

my $kickmessage = "You have been disqualified from the IRC Bonus. Thank you, and have a nice day.";

my $servertag = "servername";

my @channels = ("#channel");

my $match = "^!getfreegigs";


sub kick {
        my ($server, $channel, $nick, $message) = @_;
	$server->command("kick $channel $nick $message" ) if ( $server ); 
}

sub say {
        my ($server, $channel, $message) = @_;
        $server->command("msg $channel $message" ) if ( $server );
}

sub getdata{
	my ($server,$msg,$user,$address,$sourcechannel) = @_;
	my $chan = $server->channel_find($sourcechannel);	
	my $nick = $chan->nick_find($user);

	if (length($msg) > 80) {
		$msg = substr($msg, 0, 80);
	}

	if ($server->{ tag } eq $servertag) {
		for my $channel (@channels) {	
			if ($chan->{name} eq $channel) {
				if ($msg =~ $match) {
					if (!$nick->{op} && !$nick->{voice} && !$nick->{halfop}) {
						Irssi::print "Kicking $nick->{nick} for saying !freegigs.";
						kick($server, $channel, $nick->{nick}, $kickmessage);
					} else {
						Irssi::print "Bestowing Free gigs on $nick->{nick}";
						my $gigsmessage = "The account $nick->{nick} has been awarded 1TB. Congratulations!";
                                                say($server, $channel, $gigsmessage);
					}
				}
			}
		}
	}
}

Irssi::signal_add("message public", \&getdata);
