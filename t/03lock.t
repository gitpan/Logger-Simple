use Test::More tests=>2;
use Logger::Simple;

$logfile="t/logfile3";
$logger=Logger::Simple->new(LOG=>$logfile);

$logger->lock;
ok(-e ".LS.lock",'Lock file created');

$logger->unlock;
ok(!-e ".LS.lock",'Lock file destroyed');

unlink $logfile;

