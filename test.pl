# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use Logger::Simple;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):
my $logfile="logfile";
my $log=Logger::Simple->new(LOG=>$logfile);
if($$log{LOG} eq "logfile"){
  print "ok 2\n";
}else{
  print "not ok 2\n";
}
$log->write("Test");
if(-s $logfile){
  print "ok 3\n";
}else{
  print "not ok 3\n";
}
$log->set("Test1");
$log->set("Test2");
$sz=@{$$log{HISTORY}};
if($sz == 2){
  print "ok 4\n";
}else{
  print "not ok 4\n";
}
$m=$log->message;
if($m eq "Test2"){
  print "ok 5\n";
}else{
  print "not ok 5\n";
}

unlink $logfile;

