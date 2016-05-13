#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

#Convert a text dump like this:
#12:35:21.717 EET Apr 24 2015 : IPv4 LES CEF    : Ce0 None
#
#87526540:                            45C0004C              E@.L
#87526550: 00000000 FD11C63E 0A303001 AC1F1052  ....}.F>.00.,..R
#87526560: 007B007B 00385EBF 24040AEE 00000DEA  .{.{.8^?$..n...j
#87526570: 000028A4 C1E767CD D8E48CD6 519D50B0  ..($AggMXd.VQ.P0
#87526580: D8E48CD9 A9855D94 D8E48CD9 C161FAF9  Xd.Y).].Xd.YAazy
#87526590: 00                                   .

#... To pcap-friendly format
#http://www.networkers-online.com/blog/2015/02/text2pcap-how-to-converts-ascii-dumps-to-pcap-files/

print STDERR "Input text via STDIN\n";

open OUT, ">out.bin";
binmode OUT;

my $packetStarted = 0;
while(<STDIN>){
    my $line = $_;
    if($line=~/[0-9]+:\s+((?:[0-9A-Fa-f]+ ){1,4}) /){
	my $section = $1;
	my @sections = split(/ /, $section);
	
	#print "DBG: $line\n";
	#print Dumper(\@sections);
	
	foreach my $block (@sections){
	    if($block=~/(..)(..)?(..)?(..)?/){
                    
                my @bytes  = map { pack('C', hex($_)) } ($block =~ /(..)/g);
		
                foreach my $byte (reverse @bytes){
                        print OUT "$byte";
                }
                
	    }
	}
	
    }
    else{
	#signal an end of packet
	
	$packetStarted = 0;
    }
}
close OUT;
