#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Вычисление простых чисел

=head1 run ($x, $y)

Функция вычисления простых чисел в диапазоне [$x, $y].
Пачатает все положительные простые числа в формате "$value\n"
Если простых чисел в указанном диапазоне нет - ничего не печатает.

Примеры: 

run(0, 1) - ничего не печатает.

run(1, 4) - печатает "2\n" и "3\n"

=cut

sub run {
    my ($x, $y) = @_;
	my @arr = (1..$y);
	$arr[1] = 0;
    for (my $i = 2; $i <= $y; $i++) {
	if($arr[$i] != 0){
		if($i >= $x) { print "$i\n"; }
		for(my $j = $i**2; $j <= $y; $j += $i){
			$arr[$j] = 0;
		}
	}
        # ...
        # Проверка, что число простое
        # ...

    }
}

1;
