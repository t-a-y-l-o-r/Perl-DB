# Perl-DB
SimpleDB.pl is a basic example of a SDBM type data base in perl5.

    ~~~Options~~~
  o will list all options  
  r will read the value after accepting a key  
  l will list all elements  
  w will add an element  
  d will delete an element  
  x will DESTROY EVERYTHING PREPARE TO CRY  
  q will quit the script  



There is nothing special about this database 
and it should not be considered secure for any reason. 



Person.pm is a basic package for a person class. 
 
      ~~Access/Mutation~~~ 
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
