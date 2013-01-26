rssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
	authors => "draggy",
	name => "autoreop",
	description => "Automatically reop after being deoped",
	changed => "6.5.2008"
);

my $kickdelay = 4;

my $kicktag;

sub kick {
	my ( $data ) = @_;
	my ( $servtag, $channel, $deoper ) = split( / +/, $data );

	my $server = Irssi::server_find_tag( $servtag );
	$server->command("kick $channel $deoper leave my op alone!" ) if ( $server );
	#$server->command("autodeop start $deoper" ) if ( $server );
}

sub reop {
	my ($server, $data, $deoper, $address) = @_;
	my ( $channel, $mode, $nick ) = split( / +/, $data );

	return if ( $server->{ nick } ne $nick );

	return if ( $mode ne "-o" );

	Irssi::print "You were deoped by $deoper";

	my $servtag = $server->{ tag };
	
	$server->command("MSG chanserv op $channel $nick" ) if ( $server );

	Irssi::print "Kicking $deoper.";
	kick("$servtag $channel $deoper");
}

Irssi::signal_add( 'event mode', 'reop' );
