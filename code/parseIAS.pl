#!/usr/bin/perl -w
use strict;
use HTML::TableExtract;

# Declare the variables we'll need later.  Because I'm using
# strict, I'd get a ton of warning messages that the vars had
# already been scoped the second time through the loop otherwise.
my @files;
my $html;
my $id;
my $html_clean;
my @lines;
my @index;
my $i;
my $te;
my $datastring;
my $write_file;
my $ts;
my $row = [undef];;
my $csv;
my $line;
my @array;
my $filehandle;
my $lineno;
my $append_file;

# The first loop sanitizes the HTML pages, removing all unnecessary tag
# attributes and extra whitespace.  The original files are not
# touched; the new files are saved as "filename.clean"
@files = glob("*.html");
for( @files ) {
    $html = "$_";
    $id = $html;
    $id =~ s/\.html//;
    # print "$id\n";
    $html_clean = $html . ".clean";
    open(FILE, "<$html") || die("Cannot Open File to Edit");
    @lines = <FILE>;
    open(STDOUT, ">$html_clean") || die ("Cannot Open File to Write Edit");
    for( @lines ) {
	s/<br>/WATERLOO/gi;
	s/<p>&nbsp;<\/p>//g;
	s/&nbsp;//g;
	s/<\/*p>//gi;
	s/<\/*b>//gi;
	s/<\/*font[^>]*>//gi;
	s/ \s+/ /g;
	s/&amp;/&/gi;
	s/<table[^>]*>/<table>/gi;
	s/<td[^>]*>/<td>/gi;
	s/<tr[^>]*>/<tr>/gi;
	s/\n//g;
	s/\t//g;
	s/<table>/\n<table>/gi;
	s/<tr>/\n<tr>/gi;
	s/ </</g;
	print;
    }
    
    # The second loop extracts the seven tables from the cleaned HTML
    # files and saves them to seven CSV files. There is one CSV file per
    # table per HTML file; we'll do some cleaning of the files and then
    # cat them together at the end.
    @index = (1, 2, 3, 4, 5, 6, 7);
    foreach $i (@index) {
	$te = HTML::TableExtract->new( depth => 0, count => $i );
	open(FILE2, $html_clean) || die("Cannot Open File to Read");
	$datastring = join('',<FILE2>);
	close(FILE2);
	$te->parse($datastring);
	$write_file = $id . "_t" . $i . ".csv";
	open(OUT, ">$write_file") || die("Cannot Open File to Write");
	foreach $ts ($te->tables) {
	    # print OUT "Table (", join(',', $ts->coords), "):\n";
	    foreach $row ($ts->rows) {
		foreach (@$row) { $_ = '' unless defined $_; };
		print OUT "\"$id\",\"", join('","', @$row), "\"\n";
	    }
	}
	close(OUT);
    }
}

# The first and second table reduce to a single line when all is said and
# done; I do that here with sed.
@files = glob("*_t1.csv");
for( @files ) {
    $csv = "$_";
    $id = $csv;
    $id =~ s/_t1\.csv//;
    open(CSV1, "<$csv") || die("Cannot Open CSV File 1 to Edit");
    @lines = <CSV1>;
    open(STDOUT, ">$csv") || die("Cannot Open CSV File 1 to Write Edit");
    for( @lines ) {
	s/""/"NULL"/g;
	s/^"[^"]+","[^"]+",//g;
	s/"$/",/g;
	s/\n//g;
	print;
    }
}

# For the second table it's also necessary to remove the table labels.  This
# will happen to the third through seventh as well, but they can be looped
# because they don't involve line-munging.
@files = glob("*_t2.csv");
for( @files ) {
    $csv = "$_";
    $id = $csv;
    $id =~ s/_t2\.csv//;
    open(CSV2, "<$csv");
    @lines = <CSV2>;
    close(CSV2);
    open(CSV2, ">$csv");
    foreach $line (@lines) {
	@array = split(/,/,$line);
	print CSV2 $line unless ($array[1] eq "\"II. Details of Central Deputation\"");
    }
    close(CSV2);
    open(CSV2, "<$csv") || die("Cannot Open CSV File 2 to Edit");
    @lines = <CSV2>;
    open(STDOUT, ">$csv") || die("Cannot Open CSV File 2 to Write Edit");
    for( @lines ) {
	s/""/"NULL"/g;
	s/^"[^"]+","[^"]+",//g;
	s/"$/",/g;
	s/\n//g;
	print;
    }
    close(CSV2);
}

# This is an additional loop to the one above.  Why? Because for the life of
# me I can't figure out why it won't work IN the loop above.  It has something
# to do with how STDOUT works as a file handle, but I can't be arsed to 
# figure out why right now.
@files = glob("*_t2.csv");
for( @files ) {
    $csv = "$_";
    $id = $csv;
    $id =~ s/_t2\.csv//;
    open(CSV2, "<$csv");
    @lines = <CSV2>;
    close(CSV2);
    open(CSV2, ">$csv");
    foreach $line (@lines) {
	print CSV2 "\"$id\",", $line;
    }
    close(CSV2);
}

# Because I'm going to use a variable for a file handle, strict will throw an
# error. I therefore turn off refs before doing so.
no strict "refs";

# This loops through the various table 3-7 CSVs to remove the top matter that
# was in the tables.
@index = (3, 4, 5, 6, 7);
foreach $i (@index) {
    @files = glob("*_t$i.csv");
    for( @files ) {
	$csv = "$_";
	$id = $csv;
	$id =~ s/_t$i\.csv//;
	$filehandle = "CSV$i";
	open($filehandle, "<$csv");
	@lines = <$filehandle>;
	close($filehandle);
	open($filehandle, ">$csv");
	$lineno = 1;
	foreach $line (@lines) {
	    @array = split(/,/,$line);
	    print $filehandle $line unless ($lineno == 1 || $lineno == 2);
	    $lineno++;
	}
	close($filehandle);
    }
}

# Now we concatenate each of the seven tables together, writing the variable
# names at the top of each file.
open(DAT,">parsed/iast1.csv");
print DAT "\"name\",\"id\",\"scay\",\"recruitment\",\"dob\",\"sex\",\"podom\",\"language\",\"indlang\",\"forlang\",\"retire\",\n";
close(DAT);

#NEED TO MAKE SURE T2 HAS ID!!!
open(DAT,">parsed/iast2.csv");
print DAT "\"deputation\",\"depstart\",\"depend\",\"tenurecode\",\"deprever\",\"depdebar\",\"debarperiod\",\n";
close(DAT);

open(DAT,">parsed/iast3.csv");
print DAT "\"id\",\"slno\",\"qiup\",\"subjects\",\"division\"\n";
close(DAT);

open(DAT,">parsed/iast4.csv");
print DAT "\"id\",\"slno\",\"deslev\",\"deptoffice\",\"organization\",\"experience\",\"period\"\n";
close(DAT);

open(DAT,">parsed/iast5.csv");
print DAT "\"id\",\"slno\",\"year\",\"training\",\"institute\",\"city\",\"duration\"\n";
close(DAT);

open(DAT,">parsed/iast6.csv");
print DAT "\"id\",\"slno\",\"year\",\"training\",\"subject\",\"duration\"\n";
close(DAT);

open(DAT,">parsed/iast7.csv");
print DAT "\"id\",\"slno\",\"year\",\"training\",\"subject\",\"duration\"\n";
close(DAT);

@index = (1, 2, 3, 4, 5, 6, 7);
foreach $i (@index) {
    $append_file = "parsed/iast$i.csv";
    @files = glob("*_t$i.csv");
    for( @files ) {
	open(IN,"<$_");
	@lines = <IN>;
	open(OUT,">>$append_file");
	foreach $line (@lines) {
	    print OUT $line;
	    print OUT "\n" if($i == 1 || $i == 2);
	}
	close(OUT);
	close(IN);
    }
}
