#this code parses a file as described in box_bird_process

sub trim($)
{
        my $string = shift;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}

sub readfile(){
    ($file, $numboxes)=@_;
 
    @lines=`cat $file`;
    
    $i=0;
    while($numBoxes>$i){
	@boxdone[$i]=0;
	$i++;
    }

    $j=0;
    $realLineNum=0;
    while(scalar(@lines)>$j){
	$line=trim($lines[$j]);
	
	if($line =~ /^\#/){
	    #print("ignoring a comment line\n");
	} elsif ($line =~ /\S+/) {
	    
	    @fields=split(/\s+/,$line,5);
	    
	    if(scalar(@fields)==5){
		if($fields[0]>0 && $fields[0]<=$numboxes){
		    if($boxdone[$fields[0] - 1]==0){
			$boxdone[$fields[0] - 1]=1;
			
			$f=0;
			foreach $str(@fields){
			    
			    $current=trim($str);
			    while($current =~ /<(\d+)>/ && $1 > 0 && $1 <= $f){
				#print "\n$current matched for $1\n";
				$current =~ s/<(\d+)>/$fixed[$realLineNum][$1-1]/;
			    }
			    $fixed[$realLineNum][$f]=$current;
			    
			    #print "$fixed[$realLineNum][$f] \t";
			    $f++;
			}
			#print "\n";
			$realLineNum++;
			
		    } else {
			print("ignoring an additional line for box ".$fields[0]." in the file ".$file."\n");
		    }
		} else {
		    print("ignoring a line for box ".$fields[0]." in the file ".$file." because it is less than 0 or bigger than ".$numboxes."\n");
		}
	    } else {
		print("ignoring a line in the file ".$file." that contains something other than 5 columns\n");
	    }
	} else {
	    #print "ignoring a blank line\n";
	}
	$j++;
    }
    return @fixed;
}

1;
