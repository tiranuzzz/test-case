#!/usr/bin/env perl
use strict; 
use warnings;

my $pattern = $ARGV[0];
my $catalog = $ARGV[1];

sub get_files {
    my $path = shift;      
    opendir (my $dh, $path) or die "Failed to open directory $catalog : $!";         
    while (my $subpath = readdir $dh) {
        next if $subpath eq '.' or $subpath eq '..';
        search_in_file("$path/$subpath") if -f "$path/$subpath"; 
        get_files("$path/$subpath")      if -d "$path/$subpath";
    }
    closedir($dh);    
}

sub search_in_file {
    my $file_path = shift;    
    open(FILE, $file_path) or die "Failed to open file $file_path: $!";
    while (my $line = <FILE>) {
        if ($line =~ m/$pattern/i) {            
            print "$file_path:$. $line";
        }
    }    
    close(FILE);
}

get_files($catalog);