use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
        authors => "draggy",
        name => "autodeop",
        description => "Automatically deop a user over and over again",
        changed => "3.7.2009"
);


my $deoptarget; 

sub deop_user {
	my ( $servtag ) = @_;
	my $server = Irssi::server_find_tag( $servtag );

	if ($server && $deoptarget ne "") {
		foreach my $channel ($server->channels()) {
			my $nick = $channel->nick_find($deoptarget);

				if ($nick && $nick->{op}) {
				Irssi::print "deoping $nick->{nick} in $channel->{name}";
				$channel->command("deop $deoptarget");
			}
		}
	}
}

sub deop {
	my ($server, $data, $nick, $address) = @_;
	my ( $channel, $mode, $user ) = split( / +/, $data );

	return if ( $mode ne "+o" || $user ne $deoptarget );

	Irssi::print "deoping $user in $channel";
	$server->channel_find($channel)->command("mode -o $user" ) if ( $server );
#	$server->command("msg chanserv deop $channel $user" ) if ( $server );
}	

sub start {
	my ($server, $text, $channel) = @_;
	my ($command, $target) = split(/ +/, $text, 2);

#	Irssi::print "text: $text, command: $command, target: $target, channel: $channel";

        return if ( $command ne "!startdeop" || $target eq "" );

	my $servtag = $server->{ tag };	

	$deoptarget = $target;	

	&deop_user("$servtag");
	Irssi::signal_add( 'event mode', 'deop' );
}

sub stop {
	my ($server, $text, $channel) = @_;
	my ($command, $target) = split(/ +/, $text, 2);

        return if ( $command ne "!stopdeop" || $target eq "" );

	Irssi::signal_remove( 'event mode', 'deop' );

	$deoptarget = "";
}

Irssi::signal_add( 'message own_public', 'start' );
Irssi::signal_add( 'message own_public', 'stop' );

