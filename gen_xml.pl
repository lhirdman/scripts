#!/usr/bin/perl

use strict;

# Main
{
	my $i;
	my @files = ("POS_DATA_IXPART_HIST","POS_DATA_TBPART_HIST");
	my $file;
	for ($i=0;$i<79;$i++){
		my $num = sprintf("%02d",$i);
		#print $num."\n";
		foreach (@files)
		{
			#print $_."\n";
			$file=$_;
			my $name="$file"."$num";
			#print $name."\n";
			printit($name);
		}
	}
}

sub printit
{
	my $name=pop(@_);
	#print $name."\n";
	print "\t\t\t<Condition COLUMN_NAME=\"pctUsed\" CRITICAL=\"NotDefined\" WARNING=\"NotDefined\" OPERATOR=\"GE\" PUSH=\"TRUE\">\n";
	print "\t\t\t\t<KeyColumn COLUMN_NAME=\"name\">$name</KeyColumn>\n";
	print "\t\t\t</Condition>\n";
}
