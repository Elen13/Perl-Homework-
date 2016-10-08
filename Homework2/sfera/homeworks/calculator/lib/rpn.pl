=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub pushElLeft{
	my ($p, $t, $h, $char) = @_;
	my $ch = $#$t;
	my $pri = ${$h}{$char};
	if ($#$t != -1){
		while($ch > -1 && $pri <= ${$h}{${$t}[$ch]}){
			push @$p, ${$t}[$ch];
			pop @$t; 
			$ch  = $#$t;
		}}
	push @$t, $char;
	1;
}

sub pushElRight{
	my ($p, $t, $h, $char) = @_;
	my $ch = $#$t;
	my $pri = ${$h}{$char};
	if ($#$t != -1){
		while($ch > -1 && $pri < ${$h}{${$t}[$ch]}){
			push @$p, ${$t}[$ch];
			pop @$t; 
			$ch  = $#$t;
		}}
	push @$t, $char;
	1;
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	#my @rpn;
	
	# ...
my @chars =  @$source;
my @pol;
my @tmp;
my %hash = ("U\+" => 4, "U\-" => 4, "^" => 3, "*" => 2, "/" => 2, "+" => 1, "-" => 1, "(" => 0, ")" => 0);
my $pref = \@pol;
my $tref = \@tmp;
my $href = \%hash;

for (my $i=0; $i < scalar(@chars); $i++){
	given ($chars[$i]) {
		when (/\d+|\d+\.\d+/) { push @pol, $chars[$i]; }

		when (/\(/) { push @tmp, $chars[$i]; }

		when (/^(\+|\-)/) {pushElLeft($pref, $tref, $href,$chars[$i]);}
 
		when (/\*|\//) { pushElLeft($pref, $tref, $href,$chars[$i]); }

		when (/\^/) { pushElRight($pref, $tref, $href,$chars[$i]);} 

		when (/U\+|U\-/) { pushElRight($pref, $tref, $href,$chars[$i]);}

		when (/\)/) { for (my $j = $#tmp; $j >= 0;){
				if( $tmp[$j] ne "(") {
					push @pol, $tmp[$j];
					pop @tmp;
					$j = $#tmp; }
				else{ $j--; }
				if ($tmp[$j] eq "("){last;}
			      }
				pop @tmp;
			    }  
			   		
		default {die "Bad: '$chars[$i]'";}
	}
}
if ($#tmp != -1){
	while(@tmp){ my $c = pop @tmp;
			push @pol, $c;}
}

	return \@pol;
}

1;
