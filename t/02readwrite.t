use Test::More tests=>3; 
use Logger::Simple;

my $logfile="t/logfile2";

my $log=Logger::Simple->new(LOG=>$logfile);

$log->write("Test");
ok(-s $logfile,'Writing to logfile');

$log->set("Test1");
$log->set("Test2");
my $m=$log->message;
ok($m eq "Test2",'Retrieve last message');

$log->clear;
my $m2=$log->message;
ok(!defined $m2,'Clear error message');

unlink $logfile;

