=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

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

sub tokenize {
	chomp(my $expr = shift);
	my @res;

	# ...
	my $str = $expr;
	next if $str =~ /^\s*$/;
	$str =~ s/\s+//g;

	if($str =~ /ee/){ die "ERROR: 'ee'\n";}
	else { if($str =~ /\.\d+\./){ die "ERROR: '.3.'\n";} }
	
	my $num = qr/\d+|\d*\.\d+/;
	my $int = qr/(\+|\-)?$num(e(\+|\-)?$num)?/;
	if($str =~ /\(?$int((\+|\-|\*|\/|\^)\(?$int\)?)*/g){
		$str =~ s/((\d*)\.(\d+))/0+$1/eg;				# .7 = 0.7
		$str =~ s/($num(e(\+|\-)?$num))/0+$1/eg;		#4e4 = 40000, 4e+1 = 40, 4e-1 = 0.4, 4ee4 = error		

		$str =~ s/^(\+)(\(|\d+)/U+$2/g;
		$str =~ s/^(\-)(\(|\d+)/U-$2/g;

		$str =~ s/(\()\-(\d+)/$1U-$2/g;
		$str =~ s/(\()\+(\d+)/$1U+$2/g;

		$str =~ s/(\-|\+|\*|\/|\^)\+(\d+)/$1U+$2/g;
		$str =~ s/(\-|\+|\*|\/|\^)\-(\d+)/$1U-$2/g;

		$str =~ s/(\-|\+)\+(U\-|U\+)/$1U+$2/g;
		$str =~ s/(\-|\+)\-(U\-|U\+)/$1U-$2/g;

		@res = split m{([-+*/^)(])}, $str;
	} else
		{ die "Error: dich dich dich"; }


	our @stack;
	for my $i (@res){
		if($i eq "("){
			push @stack, $i;
		}

		if($i eq ")"){
			if(scalar(@stack) == 0){ die "Error: ) uneven number of brackets";}
		else {pop @stack;}
		}
	}
	for (my $ch=0; $ch <= $#res; $ch++){
	if($res[$ch] eq "") { 
		for (my $t=$ch; $t <= $#res; $t++){
			$res[$t] = $res[$t+1];}
		pop @res;
	}
	}
	
	for (my $ch=0; $ch <= $#res; $ch++){
	if($res[$ch] eq "U") {
		$res[$ch] = $res[$ch].$res[$ch+1];
		for (my $t=$ch+1; $t <= $#res; $t++){
			$res[$t] = $res[$t+1];}
		pop @res; 
	}
	}
	
	
	return \@res;
}

1;
