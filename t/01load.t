use Test::More tests => 3;

BEGIN{ use_ok('Logger::Simple','use Logger::Simple;'); }

my $logfile="t/logfile";
my $log=Logger::Simple->new(LOG=>$logfile);
ok($log->isa('Logger::Simple'),'Correct object created');

my $logname=$log->get_log;
ok($logname eq $logfile,'Log file is loaded');

unlink $logfile;

