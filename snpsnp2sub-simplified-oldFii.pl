#recall subgenomes based on critical SNPs
#open(IN,"C:\\RosbreedData\\snpsnp-haplotypes-6.txt");
open(IN,"C:\\RosbreedData\\Dan-Data\\snpsnp-haplotypes-oldFii.txt")||die;
while(defined($line=<IN>)){
	chomp$line;
	@temp=split("\t",$line);
	$locus=$temp[0];
	$temp[1]=~/iinumae(.*?)$/;
	$fii=$1;
	$fiinumae{$locus}=$fii;
	#print "$locus\t$fiinumae{$locus}\n";
}
close IN;	
open(IN,"C:\\RosbreedData\\Rosbreed.7764snpsnp.11112012.csv");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split(",",$line);
	$lg=$temp[2];
	$cpos=$temp[3];
	$csnp=$temp[4];
	$mpos=$temp[6];
	$msnp=$temp[7];
	$genic=$temp[11];
	
	$seq=$temp[12];
	$stream=$temp[10];
	$dis=$cpos-$mpos;
	$csnp=~/(\w)\/(\w)/;
	$cref=$1;
	$calt=$2;
	$mkey="$lg-$mpos";
	$fii=$fiinumae{$mkey};
	$gene{$mkey}=$genic;
	$seq=~/^(\w+)\[(\w)\/(\w)\](\w+)/;
	$leftseq=$1;
	$rightseq=$4;
	if($stream=~/Up/){
		$critical=substr($leftseq,$dis,1);
	}elsif($stream=~/Down/){
		$dis=$dis-1;
		$critical=substr($rightseq,$dis,1);
	}
	#print "$cpos\t$mpos\t$stream\t$seq\n$critical\n";

	@fiicsnp=();
	$subtag="N-N\tH";
	if($fii=~/\w/){
		if($critical=~/$cref/){
			$subtag=~s/N-/Y-/;
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
			$subtag=~s/\tH/\tHet/;
		}elsif($count==1){
			$subtag=~s/\tH/\tHom/;
		}	
		foreach $fiic(@fiicsnp){
			if($critical=~/$fiic/){
				$subtag=~s/-N/-Y/;
			}	
		}
		
	}else{
		$subtag="?\t?";
	}
	$subtype{$mkey}=$subtag;
	#print "Call\t$mkey\t$subtype{$mkey}\n";
}
close IN;
open(OUT,">>C:\\RosbreedData\\SNPSNP-subgenome-2-CDS-oldFii.txt");	
open(IN,"C:\\RosbreedData\\SNPSNP-subgenome-2-CDS.txt");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split("\t",$line);
	$coding=$temp[0];
	
	$lg=$temp[8];		
	$pos=$temp[9];
	$key="$lg-$pos";
	if($coding=~/N/ and $gene{$key}=~/InGenic/){
		$temp[0]="Intron";
	}elsif($coding=~/N/ and $gene{$key}=~/NonGenic/){
		$temp[0]="NonGenic";	
	}elsif($coding=~/Y/){
		$temp[0]="Exon";	
	}
	$line=join("\t",@temp);
	#print "call\t$key\t$subtype{$key}\n";
	print OUT "$subtype{$key}\t$line\n";
}
	
	
	
	