#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Шифр Цезаря https://ru.wikipedia.org/wiki/%D0%A8%D0%B8%D1%84%D1%80_%D0%A6%D0%B5%D0%B7%D0%B0%D1%80%D1%8F

=head1 encode ($str, $key)

Функция шифрования ASCII строки $str ключем $key.
Пачатает зашифрованную строку $encoded_str в формате "$encoded_str\n"

Пример:

encode('#abc', 1) - печатает '$bcd'

=cut

sub encode {
    my ($str, $key) = @_;
    my $encoded_str = '';

	my @ascii_character_numbers = unpack("C*", $str);
	for(my $i = 0; $i <= $#ascii_character_numbers; $i++){
		$ascii_character_numbers[$i] = ($ascii_character_numbers[$i] + $key) % 127;
	}
	$encoded_str = pack("C*", @ascii_character_numbers);
    # ...
    # Алгоритм шифрования
    # ...

    print "$encoded_str\n";
}

=head1 decode ($encoded_str, $key)

Функция дешифрования ASCII строки $encoded_str ключем $key.
Пачатает дешифрованную строку $str в формате "$str\n"

Пример:

decode('$bcd', 1) - печатает '#abc'

=cut

sub decode {
    my ($encoded_str, $key) = @_;
    my $str = '';

	my @ascii_character_numbers = unpack("C*", $encoded_str);
	for(my $i = 0; $i <= $#ascii_character_numbers; $i++){
		$ascii_character_numbers[$i] = ($ascii_character_numbers[$i] - $key + 127) % 127;
	}
	$str = pack("C*", @ascii_character_numbers);
    # ...
    # Алгоритм дешифрования
    # ...

    print "$str\n";
}

1;
