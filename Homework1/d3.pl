use Data::Dumper;
use DDP;
my $array;
while(<>){
	chomp;
	my @temp = split(/;/);
	for (my $i=0; $i<9; $i++){
		push @{${$array}[$i]}, $temp[$i];
	}
}
print Dumper($array);
p $array;
