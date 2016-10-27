#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Term::ReadLine;
use IO::Select;
use Local::Chat::ServerConnection;
use Data::Dumper;
$|=1;

my $term = Term::ReadLine->new('Simple perl chat');

my $server = Local::Chat::ServerConnection->new(
	nick => 'perldoc',#'T'.int(rand(10000)),
	host => $ARGV[0] || 'localhost',
	netlog => 1,
	on_fd => sub {
		my ($srv, $fd) = @_;
		if ($fd == $term->IN) {
			my $msg = $term->readline();
                        exit unless defined $msg;
			chomp($msg);
			return unless length $msg;

			if ($msg =~ m{^/(\w+)(?:\s+(\S+))*$}) {
				if ($1 eq 'nick') {
					$srv->nick($2);
					return;
				}
				elsif ($1 eq 'names') {
					$srv->names();
				}
				elsif ($1 eq 'kill') {
					$srv->kill($2);
				}
				else {
					warn "Unknown command '$1'\n";
				}
				return;
			}

			$srv->message( $msg );
			# $srv->message( $msg.2 );
			# $srv->message( $msg.3 );
		}
	},
	on_idle => sub {
	},
	on_msg => sub {
		my ($srv, $data) = @_;
		if ($data->{text} eq '!who'){
			$srv->message('I am perldoc');
		}
		if($data->{text} =~ /^perldoc./){
			my $str = $data->{text};
			$str =~ s/(perldoc\s)(.)/$1-Tt $2/;
			$srv->message($data->{from} ." " .`$str`);
		}


		if ($data->{to}) {
			printf "[%s] %s: %s\n", $data->{to}, $data->{from}, $data->{text};
		} else {
			printf "[-] %s: %s\n", $data->{from}, $data->{text};
		}
	}#,
	#on_message => sub {
	#	my ($srv, $message) = @_;
	#	add_message( $message->{from} . ": ". $message->{text} );
	#}
);



$server->sel->add($term->IN);
$server->poll;

