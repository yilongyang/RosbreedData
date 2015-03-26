#draw distribution pattern plot from Dan's subgenome called SNPSNP markers
open(IN,"C:\\RosbreedData\\distribution-oldFii.txt");#
while(defined($line=<IN>)){
	chomp$line;
	if($line=~/Linkage group file/){
		$line=~/Linkage group file\t(.*)$/;
		$file=$1;
		#print "$file\n";
	}elsif($line=~/^(Y|N|\?)/){	
		@temp=split("\t",$line);
		$call=$temp[0];		
		if($call=~/Y-N/){
			$code=1;
		}elsif($call=~/Y-Y/){
			$code=2;	
		}elsif($call=~/N-Y/){
			$code=3;	
		}elsif($call=~/N-N/){
			$code=4;	
		# }elsif($call=~/?/){
			# $code=5;	
		# }elsif($call=~/N-N-N/){
			# $code=6;
		}	
		$filecall{$file}=$filecall{$file}."$code,";
	}
}
close IN;
#$lg="LG7";


for($i=1;$i<8;$i++){
$lg="LG".$i;
$rscript="Distribution-draw-$lg-oldFii.r";
open(OUT,">>$rscript");


	print OUT "pdf(file = 'Distribution-draw-$lg-oldFii.pdf')\n";
print OUT "plot.new()\n";
print OUT "plot.window(xlim=c(-12000,-4200),ylim=c (-102000,12000))\n";
@four=("A","b","X1","X2");	
$space=0;

$start=-12000;
$height=13000;
$width=500;
foreach $abcd(@four){
	foreach $key(keys %filecall){
		if($key=~/^$lg$abcd\(/ and $key!~/DAR|MON/){
			print "File\t$key\n";
			$code=$filecall{$key}."0";
			print OUT "struct <- c($code)\n";
			#print OUT "text(-132,3000,'$lg combined',cex=1)\n";
			$abcd=~s/\(//;
			$chr=$abcd;
			print OUT "text($start+300+$space,$height,'$chr',cex=1.5)\n";
			print OUT "k <- $height-5000\n";
			$length=$code=~tr/,/,/;
			print OUT "for (i in 1: $length){\n\tif (struct[i]==1){\n boxcolour<-'red'\n d <- k-2*$width \n rect($start+$space,d+$width,$start+$width+$space,d-$width,col=boxcolour, border=NA)\n}\n";
			print OUT "\tif (struct[i]==2){\n boxcolour<-'pink'\n d <- k-2*$width \n rect($start+$space,d+$width,$start+$width+$space,d-$width,col=boxcolour, border=NA)\n}\n";
			print OUT "\tif (struct[i]==3){\n boxcolour<-'blue'\n d <- k-2*$width \n rect($start+$space,d+$width,$start+$width+$space,d-$width,col=boxcolour, border=NA)\n}\n";
			print OUT "\tif (struct[i]==4){\n boxcolour<-'green'\nd <- k-2*$width \n rect($start+$space,d+$width,$start+$width+$space,d-$width,col=boxcolour, border=NA)\n}\n";
			print OUT "\tif (struct[i]==5){\n boxcolour<-'gray'\n d <- k-2*$width \n rect($start+$space,d+$width,$start+$width+$space,d-$width,col=boxcolour, border=NA)\n}\n";
			print OUT "\tif (struct[i]==6){\n boxcolour<-'gray'\n d <- k-2*$width \n rect($start+$space,d+$width,$start+$width+$space,d-$width,col=boxcolour, border=NA)\n}\n";
			print OUT "k<-d\n}\n";
		
			$space=$space+1000;
		}
	}
}
#$space=$space+600;
if($i==7){
	$x=-7000;
	$y=-90000;
	$dis=1000;
	print OUT "boxcolour<-'red'\n rect($x,$y,$x+500,$y-$dis,col=boxcolour, border=NA)\n";
	print OUT "text($x+1000,$y,'Y-N',cex=1)\n";
	print OUT "boxcolour<-'pink'\n rect($x,$y-4*$dis,$x+500,$y-5*$dis,col=boxcolour, border=NA)\n";
	print OUT "text($x+1000,$y-4*$dis,'Y-Y',cex=1)\n";
	print OUT "boxcolour<-'blue'\n rect($x,$y-8*$dis,$x+500,$y-9*$dis,col=boxcolour, border=NA)\n";
	print OUT "text($x+1000,$y-8*$dis,'N-Y',cex=1)\n";
	print OUT "boxcolour<-'green'\n rect($x,$y-12*$dis,$x+500,$y-13*$dis,col=boxcolour, border=NA)\n";
	print OUT "text($x+1000,$y-12*$dis,'N-N',cex=1)\n";
}


	# print OUT "boxcolour<-'red'\n rect(200,-8800,250,-9000,col=boxcolour, border=NA)\n";
	# print OUT "text(300,-8900,'Y-N',cex=0.5)\n";
	# print OUT "boxcolour<-'pink'\n rect(200,-9100,250,-9300,col=boxcolour, border=NA)\n";
	# print OUT "text(300,-9200,'Y-Y',cex=0.5)\n";
	# print OUT "boxcolour<-'blue'\n rect(200,-9400,250,-9600,col=boxcolour, border=NA)\n";
	# print OUT "text(300,-9500,'N-Y',cex=0.5)\n";
	# print OUT "boxcolour<-'green'\n rect(200,-9700,250,-9900,col=boxcolour, border=NA)\n";
	# print OUT "text(300,-9800,'N-N',cex=0.5)\n";
	# print OUT "boxcolour<-'green'\n rect(200,-10000,250,-10200,col=boxcolour, border=NA)\n";
	# print OUT "text(300,-10100,'N-N-Y',cex=0.5)\n";
	# print OUT "boxcolour<-'gray'\n rect(200,-10300,250,-10500,col=boxcolour, border=NA)\n";
	# print OUT "text(300,-10400,'N-N-N',cex=0.5)\n";



print OUT "dev.off()\n";
close OUT;	
system "R CMD BATCH $rscript 'SNPSNP-draw.jpg'";

}	