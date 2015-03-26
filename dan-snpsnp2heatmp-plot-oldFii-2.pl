#color matrix of SNP subgenome type propotion values from Dan's data
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
for($m=1;$m<2;$m++){

	$lgg="LG".$m;
	$infile="C:\\RosbreedData\\Figure-4-oldFii.csv";
	$rscript="Figure-4-oldFii.r";
	open(OUT,">>$rscript");
	print OUT "pdf(file = 'Figure-4-oldFii.pdf')\n";
	print OUT "plot.new()\n";
	print OUT "plot.window(c(0,12000),c (-40000,3200))\n";

	$yspace=0;
	open(IN,"$infile");#
	$l=0;
	@red=("salmon","red","firebrick");
	@pink=("pink","hot pink", "deep pink");
	@blue=("sky blue", "royal blue", "medium blue");
	@green=("pale green", "lime green", "dark green");

	while(defined($line=<IN>)){
		chomp$line;
		$l++;
		@temp=split(",",$line);
		$xspace=0;
		# if($l==1){
			# for($i=0;$i<scalar@temp;$i++){
				# if($temp[$i]=~/A_/){
					# $colors{$i}="red";
				# }elsif($temp[$i]=~/B_/){
					# $colors{$i}="blue";
				# }elsif($temp[$i]=~/C_/){
					# $colors{$i}="green";
				# }elsif($temp[$i]=~/D_/){
					# $colors{$i}="green";
				# }
			# }
		# }	
		$colorline=0;
		if($line=~/Y-N/){
			@lightcolor=@red;
			$colorline=1;
		}elsif($line=~/Y-Y/){
			@lightcolor=@pink;
			$colorline=2;
		}elsif($line=~/N-Y/){
			@lightcolor=@blue;
			$colorline=3;
		}elsif($line=~/N-N/){
			@lightcolor=@green;
			$colorline=4;
		}
		
		for($i=0;$i<scalar@temp;$i++){
			$cell=$temp[$i];
			# if($l==1){
				# $lg=$temp[0];
				# $cell=$lg.$cell;
				# foreach $name(keys %conversion){
					# $newname=$conversion{$name};
					# if($cell=~/$name/){
						# $cell=~s/($name)/$newname/;
					# last;
					# }
				# }		
				# $cell=~s/$lg//;
			# }	
			
			
			#$color=$colors{$i};
			$x1=-150+$xspace;
			$y1=3000-$yspace+450;
			$x2=-150+$xspace+650;
			$y2=3000-$yspace-450;
			#$color=$lightcolor;
			if($colorline!=0 and $cell<0.3 and $cell=~/\d/){
				#$color=$color;
				$color=$lightcolor[0];
				print OUT "boxcolour<-'$color'\n rect($x1,$y1,$x2,$y2,col=boxcolour, border=NA)\n";
			}elsif($colorline!=0 and $cell<0.6 and $cell=~/\d/){
				#$color=$color."3";
				$color=$lightcolor[1];
				print OUT "boxcolour<-'$color'\n rect($x1,$y1,$x2,$y2,col=boxcolour, border=NA)\n";
			}elsif($colorline!=0 and $cell<1.1 and $cell=~/\d/){
				#$color=$color."4";
				$color=$lightcolor[2];
				print OUT "boxcolour<-'$color'\n rect($x1,$y1,$x2,$y2,col=boxcolour, border=NA)\n";
			}	
			#if($l>3 and $i>0){
			#	print OUT "text(100+$xspace,3000-$yspace,'$cell',cex=0.5,col='white')\n";
			#}else{
			if($l==1 or $cell=~/LG/){
				print OUT "text(120+$xspace,3000-$yspace,'$cell',cex=0.5,font=2)\n";
			}else{
				print OUT "text(120+$xspace,3000-$yspace,'$cell',cex=0.4)\n";
			}
			#}	
			
			if($i==0){
				$xspace=$xspace+950;	
			}else{
				$xspace=$xspace+650;	
			}
		}
		$yspace=$yspace+900;
	}
	close IN;	


	print OUT "dev.off()\n";
	close OUT;	
	system "R CMD BATCH $rscript 'SNPSNP-draw.jpg'";
}
