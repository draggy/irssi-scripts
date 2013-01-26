use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "1.0";
%IRSSI = (
        authors => "draggy",
        name => "profanitykick",
        description => "Kicks specified users who use profanity",
        changed => "8.7.2009"
);

my $channel = "#channel";

my @users = ("firstname", "secondname");

my @addresses = ("foo.com"); #not implemented yet

my @words = (
"sex",
"sexual",
"smex",
"rape",
"gang",
"sheep",
"goat",
"vagina",
"queef",
"orgasm",
"vulva",
"clit",
"boob",
"bewb",
"pussy",
"vag",
"twat",
"cunt",
"dick",
"cock",
"pee",
"weiner",
"sausage",
"ball",
"penis",
"seman",
"semen",
"cum",
"ass",
"butt",
"breast",
"hump",
"masterbate",
"jerk",
"porn",
"girl",
"woman",
"tit",
"tranny",
"fuck",
"fag",
"nipple",
"bj",
"blowjob",
"dildo",
"vibrator",
"lube",
"anus",
"p3n0rz",
"shaft",
"fist",
"orgy",
"bondage",
"snoofle",
"erotic",
"muff",
"gape",
"genital",
"ovarie",
"sphincter",
"testicle",
"anus",
"viagra",
"virgin",
"fondle",
"snoofle",
"horny",
"muff",
"snog",
"strapon",
"latex",
"fleshlight",
"kiss",
"squeeze",
"v\@g00",
"p3n0r",
"vagina",
"shower",
"sexes",
"kisses",
"vagoo",
"knicker",
"fapped",
"sperm",
"mound",
"pelvic",
"thrust",
"insertion",
"smexes",
"knob",
"kent",
"arse",
"lick",
"bitch",
"nake"
);


sub match {
	my ($server, $msg, $nick) = @_;
	for (@words) {
		if ($msg =~ qr/(\s|^)$_(\s|$|s+$|s+\s)/i) {
			kick($server, $nick);
			Irssi::print $nick.' was kicked for saying '.$_;
			last;
		}
	}
}

sub kick {
        my ($server, $nick) = @_;
	my $chan = $server->channel_find($channel);
	$server->command("kick $channel $nick NO sexual activity in this channel!" ) if ( $server ); 
}

sub getdata{
	my ($server,$msg,$nick,$address,$target) = @_;
	if ($target =~ $channel) {
		for (@users) {
			if ($nick =~ qr/$_/i) {
				# Strip formatting
				$msg =~ s/\x03\d?\d?(,\d?\d?)?|\x02|\x1f|\x16|\x06|\x07//g;
				match($server, $msg, $nick);
			}
		}
	}
}

Irssi::signal_add("message public", \&getdata);
Irssi::signal_add("message irc action", \&getdata);
