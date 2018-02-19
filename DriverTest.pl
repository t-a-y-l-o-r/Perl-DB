#!/usr/bin/perl
#DriverTest.pl
use Person;
use strict;
use warnings;

my $person1 = Person->new(
  surname => "Shimada",
  forename => "Hanzo",
  address => "123 Smurfing St.",
  occupation => "Try Harding",
  );

my $person2 = Person->new(
  surname => "Shimada",
  forename => "Genji",
  address => "456 Healing Rd.",
  occupation => "Wasting Q's",
  );

my %personHash = ();

# create a list of attributes assocated with each person object
my @tempList;
my $tempString;
foreach (keys %$person1){
  $tempString = join " > ", ($_, $person1->$_);
  push @tempList, $tempString;
}
$tempString = join " || ", @tempList;
$personHash{$person1->fullname} = $tempString;

# again with the second person object
$tempString = "";
@tempList = ();
foreach (keys %$person2){
  $tempString = join " > ", ($_, $person1->$_);
  push @tempList, $tempString;
}
$tempString = join " || ", @tempList;
$personHash{$person2->fullname} = $tempString;

foreach (sort keys %personHash){
  print "$_ => $personHash{$_}\n";
}
