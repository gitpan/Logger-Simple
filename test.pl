use Test::More tests=>6;

BEGIN{ use_ok('Logger::Simple','Logger::Simple loaded'); }

my $logfile="logfile";
my $log=Logger::Simple->new(LOG=>$logfile);
ok($log->isa('Logger::Simple'),'Correct object created');
ok($$log{LOG} eq "logfile",'Logfile is loaded');

$log->write("Test");
ok(-s $logfile,'Writing to logfile');

$log->set("Test1");
$log->set("Test2");
$sz=@{$$log{HISTORY}};
ok($sz == 2,'Checking History size');

$m=$log->message;
ok($m eq "Test2",'Retreiving last message');

unlink $logfile;

