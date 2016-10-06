=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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

sub evaluate {
	my $rpn = shift;

	# ...
	my @res;
	my @pol = @$rpn;

for (my $i=0; $i < scalar(@pol); $i++){
	given ($pol[$i]) {
		when (/\d+|\d+\.\d+/) { push @res, $pol[$i]; }
		when (/U\+|U\-/) { if($pol[$i] eq "U\+"){
				my $x = pop @res;
				$x = 0 + $x;
				push @res, $x;}
			     else { if($pol[$i] eq "U\-"){
					my $x = pop @res;
					$x = 0 - $x;
					push @res, $x;}
				}
			}
		when (/\^/) { my $x = pop @res;
				my $y = pop @res;
				$x = $y ** $x;
				push @res, $x; }
		when (/\*/) { my $x = pop @res;
				my $y = pop @res;
				$x = $y * $x;
				push @res, $x; }
		when (/\//) { my $x = pop @res;
				my $y = pop @res;
				$x = $y / $x;
				push @res, $x; }
		when (/\+/) { if( $pol[$i-1] ne "U") { 
				my $x = pop @res;
				my $y = pop @res;
				$x = $y + $x;
				push @res, $x; }
				}
		when (/\-/) { if( $pol[$i-1] ne "U") { 
				my $x = pop @res;
				my $y = pop @res;
				$x = $y - $x;
				push @res, $x; }
				}
		default {die "Bad: '$pol[$i]'";}
	}
}
my $r= pop @res;
	return $r;
}

1;
