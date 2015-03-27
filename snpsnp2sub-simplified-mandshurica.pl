


		foreach $fmhap(@fmandhap){
			$fmhap=~/(\w)-(\w)/;
			$fmc=$1;
			$heterkey="$mkey-$fmc";
			if(!exists $fmheter{$heterkey}){
				push(@fmcsnp,$fmc);
				$fmheter{$heterkey}++;
			}	
		}
		$count=scalar@fmcsnp;
		if($count>1){
			next;
		}elsif($count==1){
			if($critical=~/$fmcsnp[0]/){
				$subtag=~s/N-/Y-/;
			}	
		}
		@haptemp=split("=1",$fii);
		shift@haptemp;
		foreach $hap(@haptemp){
			$hap=~/(\w)-(\w)/;
			$fiic=$1;
			$heterkey="$mkey-$fiic";
			if(!exists $fiiheter{$heterkey}){
				push(@fiicsnp,$fiic);
				$fiiheter{$heterkey}++;
			}	
		}
		$count=scalar@fiicsnp;
		if($count>1){
			next;
		}elsif($count==1){
			if($critical=~/$fiicsnp[0]/){
				$subtag=~s/-N/-Y/;
			}	
		}
		
	# }elsif($fii!~/\w/){
		# $subtag=~s/N-N\tH/?\t?/;
	# }elsif($fmand=~/\w/){
		# $subtag=~s/M\tN-N/?\t?/;
		$subtype{$mkey}=$subtag;
	}
	
	
	
	#print "Call\t$mkey\t$subtype{$mkey}\n";
}
close IN;
open(OUT,">>C:\\RosbreedData\\SNPSNP-subgenome-2-CDS-mandshurica-2.txt");	
open(IN,"C:\\RosbreedData\\SNPSNP-subgenome-2-CDS-oldFii.txt");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split("\t",$line);
	#$coding=$temp[0];
	
	$lg=$temp[10];		
	$pos=$temp[11];
	$key="$lg-$pos";
	# if($coding=~/N/ and $gene{$key}=~/InGenic/){
		# $temp[0]="Intron";
	# }elsif($coding=~/N/ and $gene{$key}=~/NonGenic/){
		# $temp[0]="NonGenic";	
	# }elsif($coding=~/Y/){
		# $temp[0]="Exon";	
	# }
	#$line=join("\t",@temp);
	#print "call\t$key\t$subtype{$key}\n";
	print OUT "$subtype{$key}\t$line\n";
}
	
	
	
	
