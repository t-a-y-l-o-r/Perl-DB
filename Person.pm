#/usr/bin/perl
# Person.pm
package Person;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed); # for type checking


=head1 Person.pm - Defines a Person class

Accepts the following attributes:
  surname
  forename
  address
  occupation

Contains a class attribute: @Population, which tracks the number of Person objects that have been constructed, and stores them in an array

~~~Constructor~~~
new() -> constructor that accepts a hash

~~~Accessors~~~
surname() -> accessor/mutator
forename() -> accessor/mutator
address() -> accessor/mutator
occupation() -> accessor/mutator
headcount() -> returns the population count
population() -> returns an array of the created Person objects

~~~Util~~~
equals() -> checks if two objs are the same
fullname() -> returns the full name of the person
printleter() -> prints a properly formatted leter 
=cut


my @Population; # number of Person objects created

# ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~CONSTRUCTOR~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~
=head1 new()
A constructor method that calls to a hiden method to add the current construct to the Population array, instead of to the variable itself.
=cut
sub new{
  my $class = shift;
  my $self = {@_};
  bless($self, $class);
  $self->_init;
  return $self;
}


# ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~Under the Hood~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~
=for
This method pushes the current object to the everyone array, adding it to the list of tracked objects.
=cut
sub _init{
  my $self = shift;
  push @Population, $self;
  # carp "New object created.\n";
}


# ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~Accessors/Mutators~~
# ~~~~~~~~~~~~~~~~~~~~~~~
=head2 surname()
A simple accessor that duels as a mutator method if an argument is passed. Changes and returns the stored surname
=cut
sub surname{
  my $self = shift;
  unless (ref $self){
    croak "surname() should only be called from an object context, not from a class.";
  }
  my $data = shift;
  $self->{surname} = $data if defined $data;
  return $self->{surname};
}

=head3 forename()
A simple accessor that duels as a mutator method if an argument is passed. Changes and returns the stored forename
=cut
sub forename{
  my $self = shift;
  unless (ref $self){
    croak "forename() should only be called from an object context, not from a class.";
  }
  my $data = shift;
  $self->{forename} = $data if defined $data;
  return $self->{forename};
}

=head4 address()
A simple accessor that duels as a mutator method if an argument is passed. Changes and returns the stored address
=cut
sub address{
  my $self = shift;
  unless (ref $self){
    croak "address() should only be called from an object context, not from a class.";
  }
  my $data = shift;
  $self->{address} = $data if defined $data;
  return $self->{address};
}

=head5 occupation()
A simple accessor that duels as a mutator method if an argument is passed. Changes and returns the stored occupation
=cut
sub occupation{
  my $self = shift;
  unless (ref $self){
    croak "occupation() should only be called from an object context, not from a class.";
  }
  my $data = shift;
  $self->{occupation} = $data if defined $data;
  return $self->{occupation};
}

=head6 population()
Returns the population array. The array is a list of all known Person objects that have been recently created.
=cut
sub population{@Population}

=head7 headcount()
Returns the quantity of Person objects stored in the population array
=cut
sub headcount{scalar @Population}

# ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~Utility~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~
=head7 equals()
Determines whether or not the passed object is identical to the calling object. Checks type first, then checks each attribute. Returns 1 for true, and undefined for false
=cut
sub equals{
  my $self = shift;
  unless (ref $self){
    croak "equals() should only be called from an object context, not from a class.";
  }
  my $object = shift;
  my $class1 = blessed($self);
  my $class2 = blessed($object);
  if ($class1 eq $class2){
    if ($self->{surname} eq $object->{surname}){
      if ($self->{forename} eq $object->{forename}){
        if ($self->{address} eq $object->{address}){
          if ($self->{occupation} eq $object->{occupation}){
            return 1;
          }
        }
      }
    }
  }
  return undef;
}


=head8 fullname()
Returns the full name of the person
=cut
sub fullname{
  my $self = shift;
  unless (ref $self){
    croak "fullname() should only be called from an object context, not from a class.";
  }
  return $self->{forename}." ".$self->{surname};
  # . operator concats two strings
}


=head9 printletter()
Accepts the body of a paragraph, and returns a formatted letter with the current Person objects data appened to it.
=cut
sub printletter{
  my $self = shift;
  unless (ref $self){
    croak "printletter() should only be called from an object context, not from a class.";
  }
  my $name = $self->fullname;
  my $address = $self->address;
  my $forename = $self->forename;
  my $sendingToPerson = shift; # grab the person being addressed
  my $sendingToName = $sendingToPerson->surname;
  my $body = shift; # grab the words from the passed arg
  my @date = (localtime) [3, 4, 5]; # grabs the day/month/year as an array
  $date[1]++; # be defualt the month starts at 0
  $date[2] += 1900; # years count from 1900, add to find current year
  my $date = join "/", @date; # joins the array into a string with / between each array part
  print <<EOF;
  $name
  $address

  $date

  Dear $sendingToName,

  $body

  Yur frind,
  $forename
EOF
    return $self; #EOF can't have spaces before or after in order to work
}

1;
