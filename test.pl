use Test::More tests=>9;

#1
BEGIN{ use_ok('Logger::Simple','use Logger::Simple;'); }

#2
my $logfile="logfile";
my $log=Logger::Simple->new(LOG=>$logfile);
ok($log->isa('Logger::Simple'),'Correct object created');

#3
my $log_name=$log->get_log;
ok($log_name == $logfile,'Logfile is loaded');

#4
$log->write("Test");
ok(-s $logfile,'Writing to logfile');

#5
$log->set("Test1");
$log->set("Test2");
my $m=$log->message;
ok($m eq "Test2",'Retrieving last message');

#6
my @m=$log->message;
my $s=@m;
ok($s == 2,'Retrieving Message History');

#7
$log->lock;
ok( -e ".LS.lock",'Lock File created');

#8
$log->unlock;
ok(!-e ".LS.lock",'Lock File destroyed');

#9 
$log->clear;
my $m2=$log->message;
ok(!defined $m2,'Clear error message');

unlink $logfile;

