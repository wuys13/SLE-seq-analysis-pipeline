use strict;
use warnings;
use autodie;

if(@ARGV<2){
	  print "perl $0 <sam: wellcode umi> <output> gtf\n";
	  exit;
}
my $ha;
open GTF,"$ARGV[3]";
while(<GTF>){
	next if(/^#/);
	my @a=split /\t/,$_;
	if($a[2] eq "exon"){
		for($a[$a[3]..$a[4]]){
			$ha{$a[0]}{$_}="";
		}
	}
	
}
my %sam;

my %total;

open FO,">$ARGV[1]\n";
my $time=localtime();
print  "$time\n";

read_sam($ARGV[0],"human");
open LIST,"$ARGV[2]";
my @sort;
while(<LIST>){
	chomp;
	my @a=split /\s+/,$_;
	push @sort,$a[0];
}
close LIST;
print FO "wellcode\ttotal_reads\ttotal_umi_kinds\tmapped_reads\texon_mapped_reads\tmapped_umi_kinds\n";
#foreach my $wellcode(keys %sam){
foreach my $wellcode(@sort){
	  
	  my $total_reads=keys %{$sam{$wellcode}{read}{total}};
	  my $total_umi=keys %{$sam{$wellcode}{umi}{total}};
	  my $reads=keys %{$sam{$wellcode}{read}{mapped}};
	  my $exon_reads=keys %{$sam{$wellcode}{read}{mapped_exon}};
	  my $umi=keys %{$sam{$wellcode}{umi}{mapped}};
	  print FO "$wellcode\t$total_reads\t$total_umi\t$reads\t$exon_reads\t$umi\n";
}



sub read_sam {
	  my ($file,$tag)=@_;
	  

   open FF,$file;
    while(<FF>){
    	  next if /^@/;
    	  chomp;
    	  my @terms=split /\t/,$_;
    	  my $flag=0;
    
    	  if($terms[1] & 0x40){
    	  	 $flag=1;
    	  	 
    	  }
    	  
    	  $total{"total_reads_$tag"}{"$terms[0].$flag"}++ ;
    
    	  my @id=split /:/,$terms[0];
    	  my $read="$terms[0].$flag";
    	  
    	  $sam{$id[-2]}{read}{total}{$read}++;
    	  $sam{$id[-2]}{umi}{total}{$id[-1]}++;
    	 
    	  if($terms[2] ne "*" and $terms[5] ne "*"){
    	  	  
    	  	  $sam{$id[-2]}{read}{mapped}{$read}++;
    	  	  $sam{$id[-2]}{umi}{mapped}{$id[-1]}++;
    	  	  if(exists $ha{$terms[2]}{3}){
			$sam{$id[-2]}{read}{mapped_exon}{$read}++;
		  }
    	  }
    	
    }
    
}    
#exit;
close FF;
$time=localtime();
print  "$time\n";
#my %uniq;



