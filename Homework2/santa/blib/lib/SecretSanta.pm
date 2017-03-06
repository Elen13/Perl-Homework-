package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {

	my @members = @_;
	my @res;
	my %res;
	my @random_list;
	my %family_list;
	my $person;
	my $cnt = 0;

	for my $i (@members){
		if(ref($i) eq "ARRAY"){
			for my $j (@$i){
				$family_list{$j} = $cnt;
				push @random_list,$j;
			}
		}
		else{ push @random_list,$i; }
		$cnt++;
	}

	my $check = 0;
	my @list = @random_list;
	while($check == 0){
		for my $santa (@list){
			$person = @random_list[rand @random_list];
			@random_list = grep { $_ ne $person } @random_list;
			# ...
			$res{$santa} = $person;
			#push @res,[ $santa, $person ];
			# ...

		}
		@random_list = @list;
		for my $k (keys %res){
			if($k eq $res{$k}){  
				$check = 0; 
				last; 
			}
			else{ $check = 1; }
			if($res{$res{$k}} eq $k){ 
				$check = 0; 
				last; 
			}
			else{ $check = 1; }
			if(exists $family_list{$k} && exists $family_list{$res{$k}}){
				if($family_list{$k} == $family_list{$res{$k}}){  
					$check = 0; 
					last; 
				}
			else{ $check = 1; }
			}
		}
	}
	
	while (my ($k,$v) = each %res) {
		push @res,[ $k, $v ];
	}

	return @res;
}

1;
