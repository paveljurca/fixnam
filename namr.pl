#!/usr/bin/env perl
use strict;
use warnings;

my $dir = shift || "";
die "$!\n" unless -d $dir;

chdir $dir;
opendir(my $dir_entry, q|.|);

for my $file (readdir $dir_entry) {
  next if -d $file or $file =~ /^\./;

  print $file, "\n";
}
closedir $dir_entry;

sub hier {
}

sub namr {
  #my $ext = /(\.[^.]+)\z/;
  #warn "$!\n" if -e $file;
}

# sort
# rekurze
# opendir
# chdir

# [-f]
#DEFUALT: no actual renaming!!
##a debug msg of the possible replacement

#non-mp3 files
# u sure? [y/n]
