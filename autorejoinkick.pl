use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
        authors => "draggy",
        name => "autorejoinkick",
        description => "Automatically rejoin a channel and kick the kicker",
        changed => "6.23.2010"
);


my $joindelay = 1;

my $kicktag;
my $bantag;


sub rejoin {
        my ( $data ) = @_;
        my ( $servtag, $channel ) = split( / +/, $data );
        my $server = Irssi::server_find_tag( $servtag );

	# Rejoin channel
	if (($servtag eq "withinside") && ($channel eq "#channel")) {
		$server->command( "j #channel password" ) if ( $server );
	} elsif ($servtag eq "servername") {
		# Unban just in case
		$server->command( "MSG chanserv unban $channel" ) if ( $server );
		$server->command( "MSG chanserv invite $channel" ) if ( $server );
        } elsif ($servtag eq "awesomehd") {
		$server->command( "MSG Botname ENTER $channel mynick mypass" ) if ( $server );
        } else {
		# Default auto attempt
		$server->command( "j $channel" ) if ( $server );
	}
}

sub kick {
        my ( $data ) = @_;
        my ( $servtag, $channel, $kicker ) = split( / +/, $data );
        my $server = Irssi::server_find_tag( $servtag );
	my $chan = $server->channel_find($channel);

        if ($chan->{chanop}) {
       		$server->command("kick $channel $kicker Don't let the door hit you on the way out" ) if ( $server ); 
		Irssi::timeout_remove( $kicktag );
	}
}

sub ban {
        my ( $data ) = @_;
        my ( $servtag, $channel, $address ) = split( / +/, $data );
        my $server = Irssi::server_find_tag( $servtag );
	my $chan = $server->channel_find($channel);

	if ($chan->{chanop}) {
	        $server->command("mode $channel +b $address" ) if ( $server );
		Irssi::timeout_remove( $bantag );
	}
}

sub event_rejoin_kick {
        my ($server, $data, $kicker, $address) = @_;
        my ( $channel, $nick ) = split( / +/, $data );

        return if ( $server->{ nick } ne $nick );

        Irssi::print "You were kicked by $kicker";

        my $servtag = $server->{ tag };

        Irssi::print "Rejoining $channel in $joindelay seconds.";

        rejoin("$servtag $channel");

	if ($servtag eq "servername") {
		# Kicking if opped
		Irssi::print "Kicking $kicker when opped";
		$kicktag = Irssi::timeout_add( 1 * 1000, "kick", "$servtag $channel $kicker" );
		# Banning if opped
		Irssi::print "Banning $kicker when opped";
		$bantag = Irssi::timeout_add( 1 * 1000, "ban", "$servtag $channel $address" );
	}
}

Irssi::signal_add( 'event kick', 'event_rejoin_kick' );
