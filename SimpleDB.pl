#!/usr/bin/perl
#SimpleDB.pl
use strict;
use warnings;
use POSIX;
use SDBM_File;
use Carp;
use Switch;


=head1 SimpleDB.pl - A simple database script
This simple script shows an example of database management

1) Creates the db
2) Loops until the user enters 'q'
3) o will list all options 
4) r will read the value after accepting a key
5) fr will read the contents of a file and store it in the database
6) fw will write the contents of the databast to a file
5) l will list all elements
6) w will add an element
7) d will delete an element
8) x will DESTROY EVERYTHING PREPARE TO CRY
9) q will quit
=cut 


# #############################
# ############ MAIN ###########
# #############################


=head1
Creates the data base && works as a driver for the remander of the script
=cut
my %database;
my $database_file = "Simple.dbm";
tie %database, 'SDBM_File', $database_file, O_CREAT|O_RDWR, 0644;
# let the user know if the file was created/opened or not
if (tied %database){
  print "File $database_file now open.\n";
}
else{
  die "Sorry unable to open $database_file.\n";
}
$_ = ""; # ensures that the base var is defined
until (/^q/i){ 
# checks to see if q/Q is at the begining, allowing the user to quit
  print "What would you like to do? (o for options): \n";
  # chomp removes trailing newlines from the input
  chomp ($_ = <STDIN>);
  # run subroutine associated with the passed option
  if ($_ =~ /^o/i) {optionsDB()}
  elsif ($_ =~ /^r/i) {readDB()}
  elsif ($_ =~ /^(fr)/i) {fileReadDB()}
  elsif ($_ =~ /^(fw)/i) {fileWriteDB()}
  elsif ($_ =~ /^l/i) {print listDB();}
  elsif ($_ =~ /^w/i) {writeDB()}
  elsif ($_ =~ /^d/i) {deleteDB()}
  elsif ($_ =~ /^x/i) {clearDB()}
  elsif ($_ =~ /^q/i) {print "Bye bye!\n";}
  else{ print "Sorry, not a recognized option.\n";}
}
untie %database; # close up house


# #############################
# ########## OPTIONS ##########
# #############################
=head1
Lists the avaiable options
=cut
sub optionsDB{
  print<<EOF;
  Options avaiable:
  o - view options
  r - read entry
  fr - read entries from a file
  fw - write entries to a file
  l - list all entries
  w - write an entry
  d - delete an entry
  x - delete all entrie
  q - to quit
EOF
}


# #############################
# ############ INPUT ##########
# #############################


=head1
Gets the key name entry from the user
=cut
sub getkey{
  print "Enter a key name of the element (case-sensitive): \n";
  chomp ($_ = <STDIN>);
  $_ =~ s/^\s+|\s+$//g;  # will remove trailing and leading white space
  return $_;
}

=head1
Gets the value entry from the user
=cut
sub getvalue{
  print "Enter a value name of the element: \n";
  chomp ($_ = <STDIN>);
  $_ =~ s/^\s+|\s+$//g;
  return $_;
}

=head1
Asks the user if they are absolutely sure they want to execute the above process
=cut
sub besure{
  print "Are you sure? (y\\n)\n";
  $_ = <STDIN>;
  /^y/i;
}

=head1
Reads in a file name
=cut
sub getFile{
  print "File to read from: \n";
  chomp (my $filename = <STDIN>);
  return $filename;
}

=head1
Writes the user input as an entry to the databse
=cut
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


# #############################
# ######### OUTPUT ############
# #############################


=head1
Formates a person object entry before outputting it
=cut
sub formate{
  $_ = $database{$_};
  my $total = "";
  @_= split /\|\|/, $_;
  foreach (sort @_){
    $_ =~ s/^\s+|\s+$//g;
    $total .= "\t$_\n"; # . concats two strings
  }
  return $total;
}

=head1
Reads the specific entry entered by the user, if it exists.
=cut
sub readDB{
  my $keyname = getkey();
  if (exists $database{$keyname}){
    print $database{$keyname}, "\n";
  }
  else{
    print "Sorry, this element doesn't exist.\n";
  }
}

=head1
Lists all currently stored entries
=cut
sub listDB{
  my $total = "";
  foreach (sort keys %database){
    $total .= "$_:\n";
    $total .= "$database{$_}\n";
  }
  return $total;
}


# #############################
# ######### CLEANUP ###########
# #############################


=head1
Deletes the entry the user enters
=cut
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

=head1
Makes you cry if you didn't mean to
=cut
sub clearDB{
  print "This will delete the ENTIRE DATA BASE.\n";
  print "Are you 100000% sure you want to PERMENTLY DESTROY EVERYTHING?\n";
  undef %database if besure();
}


# #############################
# ####### FILEHANDLING ########
# #############################


=head1
Writes the entire data base to a file. Each value is stored and sperated by 
commas. The key name should always be taken as the forename+surname.
=cut
sub fileWriteDB{
  print "File name to write to: ";
  chomp (my $filename = <STDIN>);
  open (FILE, ">", $filename);
  my $total = "";
  foreach (sort keys %database){
    $total .= $_ . ":\n". $database{$_} . ",\n";
  }
  print FILE $total;
  close FILE;
  print "Done writing to file $filename!\n";
}


=head1
Reads data from a csv file. Assumes the data is formatted like so:
Key:
  forename > Genji
  surname > Shimada
  address > 456 Healing Rd.
  occupation > Wasting Q's
,

The comma at the end is required 
=cut
sub fileReadDB{
  my $entries = 0;
  my $filename = getFile;
  my $key;
  my $value = "";
  open(FILE, "<", $filename) or croak "Unable to open $filename.\n";
  while (my $line = <FILE>){
    $_ = $line;
    switch ($_){
      case m/(\w+)(\s)?(:)/ {
        # chomp $_;
        $_ =~ s/(^\s+)|(\s+$)(\n)?|(:)(\n)?//g; 
        $key = $_;
      } 
      # key name is followed by a ':'
      case m/(\t)?(\s)?(surname > )/ {
        $_ =~ s/(^\s+)|(\s+$)//g; 
        $value .= "\t" . $_ . "\n";
      }
      case m/(\t)?(\s)?(forename > )/ {
        $_ =~ s/(^\s+)|(\s+$)//g; 
        $value .= "\t" . $_ . "\n";
      }
      case m/(\t)?(\s)?(address > )/ {
        $_ =~ s/(^\s+)|(\s+$)//g; 
        $value .= "\t" . $_ . "\n";
      }
      case m/(\t)?(\s)?(occupation > )/ {
        $_ =~ s/(^\s+)|(\s+$)//g; 
        $value .= "\t" . $_ . "\n";
        $database{$key} = $value;
      }
      case m/(\t)?(\s)?(,)/ {
        $key = ""; 
        $value = ""; 
        $entries++; 
        next
      } 
      # clears everything
      else {croak "$_\nSomething went horribly wrong in the Switch-case.\n"}
    }
  }
  print "Entries added: $entries\n";
}