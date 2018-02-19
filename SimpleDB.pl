#!/usr/bin/perl
#SimpleDB.pl
use strict;
use warnings;
use POSIX;
use SDBM_File;


=head1 SimpleDB.pl - A simple database script
This simple script shows an example of database management

1) Creates the db
2) Loops until the user enters 'q'
3) o will list all options 
4) r will read the value after accepting a key
5) l will list all elements
6) w will add an element
7) d will delete an element
8) x will DESTROY EVERYTHING PREPARE TO CRY
=cut 


my %database;
my $database_file = "Simple.dbm";

# make database
tie %database, 'SDBM_File', $database_file, O_CREAT|O_RDWR, 0644;


# let the user know if the file was created/opened or not
if (tied %database){
  print "File $database_file now open.\n";
}
else{
  die "Sorry unable to open $database_file.\n";
}

$_ = ""; # ensures that the base var is defined


until (/^q/i){ # checks to see if q/Q is at the begining, allowing the user to quit
  print "What would you like to do? (o for options): \n";
  # chomp removes trailing newlines from the input
  chomp ($_ = <STDIN>);
  # run subroutine associated with the passed option
  if ($_ eq "o") {optionsDB()}
  elsif ($_ eq "r") {readDB()}
  elsif ($_ eq "l") {listDB()}
  elsif ($_ eq "w") {writeDB()}
  elsif ($_ eq "d") {deleteDB()}
  elsif ($_ eq "x") {clearDB()}
  elsif ($_ =~ /^q/i) {print "Bye bye!\n";}
  else{ print "Sorry, not a recognized option.\n";}
}

# close up house
untie %database;

# ~~~OPTIONS~~~
sub optionsDB{
  print<<EOF;
  Options avaiable:
  o - view options
  r - read entry
  l - list all entries
  w - write an entry
  d - delete an entry
  x - delete all entrie
  q - to quit
EOF
}


sub readDB{
  my $keyname = getkey();
  if (exists $database{$keyname}){
    print "Element '$keyname' has value: $database{$keyname}\n";
  }
  else{
    print "Sorry, this element doesn't exist.\n";
  }
}


sub listDB{
  foreach (sort keys %database){
    print "$_ => $database{$_}\n";
  }
}


sub writeDB{
  my $keyname = getkey();
  my $keyvalue = getvalue();

  if (exists $database{$keyvalue}){
    print "Sorry, this element already exists.\n";
  }
  else{
    $database{$keyname} = $keyvalue;
  }
}


sub deleteDB{
  my $keyname = getkey();

  if (exists $database{$keyname}){
    print "This will delete the element.\n";
    delete $database{$keyname} if besure();
  }
  else{
    print "Sorry, this element does not exists.\n";
  }
}


sub clearDB{
  print "This will delete the ENTIRE DATA BASE.\n";
  print "Are you 100000% sure you want to PERMENTLY DESTROY EVERYTHING?\n";
  undef %database if besure();
}



# ~~~INPUT~~~

sub getkey{
  print "Enter a key name of the element: \n";
  chomp ($_ = <STDIN>);
  $_;
}


sub getvalue{
  print "Enter a value name of the element: \n";
  chomp ($_ = <STDIN>);
  $_;
}


sub besure{
  print "Are you sure? (y\\n)\n";
  $_ = <STDIN>;
  /^y/i;
}


