#find markers used in Dan data
#read assiged markers from all extended list
%conversion=(
"LG1A"=>"LG1A",
"LG1C"=>"LG1b",
"LG1D"=>"LG1X1",
"LG1B"=>"LG1X2",
"LG2B"=>"LG2A",
"LG2D"=>"LG2b",
"LG2A"=>"LG2X1",
"LG2C"=>"LG2X2",
"LG3A"=>"LG3A",
"LG3C"=>"LG3b",
"LG3D"=>"LG3X1",
"LG3B"=>"LG3X2",
"LG4A"=>"LG4A",
"LG4C"=>"LG4b",
"LG4D"=>"LG4X1",
"LG4B"=>"LG4X2",
"LG5D"=>"LG5A",
"LG5B"=>"LG5b",
"LG5A"=>"LG5X1",
"LG5C"=>"LG5X2",
"LG6B"=>"LG6A",
"LG6D"=>"LG6b",
"LG6A"=>"LG6X1",
"LG6C"=>"LG6X2",
"LG7C"=>"LG7A",
"LG7B"=>"LG7b",
"LG7D"=>"LG7X1",
"LG7A"=>"LG7X2",

);
open(IN,"C:\\RosbreedData\\SNPSNP-subgenome-2-CDS-simple.txt")||die;#
while(defined($line=<IN>)){
	chomp$line;
	@temp=split("\t",$line);
	$lg=$temp[10];
	$pos=$temp[11];
	$snpkey="$lg-$pos";
	if($temp[1]=~/Hom/){
		$snp{$snpkey}="$temp[0]";			##
	}	
	#print "$snpkey\t$snp{$snpkey}\n";
}
close IN;
open(IN,"C:\\RosbreedData\\dan-lg-list.txt");
$out="C:\\RosbreedData\\distribution-newcall.txt";   #
open(OUT,">>$out");
while(defined($line=<IN>)){
	chomp$line;
	$line=~/PUBLICATION-LG(\d)(.*?).txt/;
	$hlg="LG".$1;
	$parent=$2;
	$parent=~s/\s//;
	$file=$hlg.$parent;
	foreach $name(keys %conversion){
		$newname=$conversion{$name};
		if($file=~/$name/){
			$file=~s/($name)/$newname\($1\)-/;
			last;
		}		
	}	
	print "$line\n";
	print OUT "Linkage group file\t$file\n";
	open(DA,"$line")||die;
	$l=0;
	if(!exists $parents{$parent}){
		push(@group,$parent);
		$parents{$parent}++;
		
	}
	while(defined($daline=<DA>)){
		chomp$daline;
		$snpkey="";
		@temp=split("\t",$daline);
		$snpkey="$temp[2]-$temp[3]";
		#print "$snpkey\n";
		if($snpkey!~/\w/){
			next;
		}	
		$snpsub=$snp{$snpkey};
		#$snpsub=~s/\?/N/g;
		#print "$daline\n";
		$l++;
		if($l==1){
			print OUT "Subgenome Category\t$daline\n";
		}
		if(!exists $alltag{$snpsub}){
			$alltag{$snpsub}++;
			push(@tags,$snpsub);
		}
		if(exists $snp{$snpkey}){
			print OUT "$snpsub\t$daline\n";
			#print "$snpsub\t$daline\n";
			$snpcount{$snpkey}++;
			$heatmapkey="$hlg\t$parent\t$snpsub";
			$heatmapcount{$heatmapkey}++;
			if($parent=~/DAR/){
				$parentkey="DA\t$snpsub";
				$parentcount{$parentkey}++;
			}elsif($parent=~/MON/){
				$parentkey="MON\t$snpsub";
				$parentcount{$parentkey}++;
			}else{
				$parentkey="Combined\t$snpsub";
				$parentcount{$parentkey}++;
			}	
		}
				
	}
	
	print OUT "\n";
	close DA;
	
}
#close OUT;	# $asnpsum=scalar keys%asnp;
$total=keys %snpcount;
print OUT "Total\t$total\n\n";
# foreach $key(keys %snpcount){
	 # print OUT "$key\t$snpcount{$key}\n";
# }
print OUT "\n";
 for($i=1;$i<8;$i++){
	 $lg="LG".$i;
	 print OUT "\n$lg\n";
	 foreach $tag(@tags){
		 $header="";
		 $number="";
		 #print "TAG\t$tag\n";
		 foreach $match(@group){
			 $header=$header."$match\t";
			 $countkey="$lg\t$match\t$tag";
			 #print "keys\t$countkey\n";
			 if(!exists $heatmapcount{$countkey}){
				 $heatmapcount{$countkey}=0;
			 }	
			 $number=$number."$heatmapcount{$countkey}\t";
		 }
		 print OUT "$tag\t$number\n";
	}
	 print OUT "$lg\t$header\n";
	
 }

 print OUT "\n";
 foreach $key(keys %parentcount){
	 print OUT "$key\t$parentcount{$key}\n";
}
	