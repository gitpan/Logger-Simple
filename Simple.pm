package Logger::Simple;
use strict;
use Carp;
use FileHandle;
use Fcntl qw(:flock);
use Time::HiRes qw/usleep/;
use vars qw /$VERSION $SEM $ms/;

$ms=750_000;
$VERSION='1.081';
$SEM = ".LS.lock";

sub new{
  my($class,%args)=@_;
  my $self =  bless{LOG        => $args{LOG} || croak"No logfile!\n",
                    CARP       => $args{CARP} || undef,
                    FILEHANDLE => new FileHandle || croak"Unable to get filehandle\n",
		    SEMAPHORE  => new FileHandle || croak"Unable to create semaphore filehandle\n",
                    ERROR      => "",
                    HISTORY    => [],
              },$class;

  if(! $self->open_log()){
    die"Unable to open $self->{LOG}\n";
  }

  return $self;
}

sub get_log{
  my $self=shift;
  return $$self{LOG};
}

sub open_log{
  my $self=shift;
  if(! open($$self{FILEHANDLE},">>$$self{LOG}")){
    $self->set("Unable to open logfile\n");
    return 0; 
  }
  $$self{FILEHANDLE}->autoflush(1);
  return 1;
}

sub write{
  my($self,$msg)=@_;
  my $FH=*{$$self{FILEHANDLE}};
  my $format="$0 : [".scalar (localtime)."] $msg";
  ## Fix to ignore locking on Win32
  if($^O eq "MSWin32"){}else{
    $self->lock();
  }
  if(! print $FH "$format\n"){
    $self->set("Unable to write to $$self{LOG}: $!\n");
  }
  if($^O eq "MSWin32"){}else{ 
    $self->unlock();
  }
}
sub message{
  my $self=shift;

  if(wantarray){
    my @messages=@{$$self{HISTORY}};
    return @messages;
  }else{
    my $message=$$self{ERROR};
    return $message;
  } 
}

sub clear{
  my $self=shift;
  $$self{ERROR}=undef;
}

sub set{
  my ($self,$error)=@_;
  $self->clear;
  $$self{ERROR}=$error;

  push @{$$self{HISTORY}},$error;
  carp "$error\n" if $$self{CARP};
  $self->write($error);
}

sub print_object{
  require Data::Dumper;
  my $self=shift;
  print Data::Dumper->Dumper($self);  
}

sub lock{
  my $self=shift;
  
  open $$self{SEMAPHORE},">$SEM"||die"Can't create lock file: $!\n";
  flock($$self{SEMAPHORE},LOCK_EX) or die"Can't obtain file lock: $!\n";
}

sub unlock{
  my $self=shift;
  if(-e $SEM){
    flock($$self{SEMAPHORE},LOCK_UN);
    close $$self{SEMAPHORE};
    $$self{SEMAPHORE}->autoflush(1);
    if($^O eq "MSWin32"){ system "del $SEM"; }else{
      unlink $SEM;
    }
  }
}

sub wait{
  while(-e $SEM){
   usleep $ms;
  }
}
1;
__END__

=head1 NAME

Logger::Simple - Implementation of the Simran-Log-Log and Simran-Error-Error modules

=head1 SYNOPSIS

  use Logger::Simple;
  my $log=Logger::Simple->new(LOG=>"/tmp/program.log",CARP=>'1');
  my $x=5;my $y=4;
  if($x>$y){
    # Set an error message
    $log->set("\$x is greater than \$y");
  }
  $log->set("Another Error message");

  $log->write("Information Message");

  # Get entire Error Message History
  my @msgs = $log->message;
  foreach my $m(@msgs){
    print "Message: $m\n";
  }

  # Get the last set error message
  my $message=$log->message;
  print "Message: $message\n";

  # Get the name of the error log
  my $log_name=$log->get_log;

=head1 DESCRIPTION

=over 5

=item new

C<< new(LOG=>"/tmp/logfile",CARP=>'1'); >>

This creates the Logger::Simple object, and initializes it with two parameters.
The LOG parameter is the name of the file to which the object will write the
log. The CARP parameter will provide more error reporting within the object.
Upon creation of the object, it will also make a call to the open method, 
which opens the file using the FileHandle object that is stored within the
FILEHANDLE parameter.

=item set

C<< set("This is an error message"); >>

This method takes an argument of a string and saves it within two parameters of
the object. It saves it in the ERROR parameter, which is the last error message
that is set, and it saves it to the HISTORY parameter, which is an array that
contains all set error messages. This method also calls the write method, which
will write the error to the log. 

=item write

C<< write("This is a log message"); >>

This method takes an argument of a string and writes it to the open logfile
that was opened upon creation of the Logger::Simple object.

=item message

C<< @array = $object->message; >>

          or

C<< $msg = $object->message; >>

When this method is called in a list context, it will return the HISTORY
parameter within the object, which is an anonymous array. When called in a
scalar context, it returns the last error message that was set, which is in
the ERROR parameter of the object.

=item get_log

C<< $log_name = $object->get_log; >>

When this method is called, it will return the LOG parameter within the
object, which is the name of the logfile that was passed at the creation
of the object.

=back

=head1 EXPORT

None by default.

=head1 ACKNOWLEDGEMENTS

This module is based on the Simran::Log::Log and Simran::Error::Error
modules. I liked the principle behind them, but felt that the interface
could be a bit better.

My thanks also goes out once again to Damian Conway for Object Oriented Perl,
and also to Sam Tregar, for his book "Writing Perl Modules for CPAN". Both
were invaluable references for me.

=head1 AUTHOR

Thomas Stanley

Thomas_J_Stanley@msn.com

I can also be found on http://www.perlmonks.org as TStanley. You can also
direct any questions concerning this module there as well.

=head1 COPYRIGHT

=begin text

Copyright (C) 2002-2003 Thomas Stanley. All rights reserved. This program is free software; you can distribute it and/or modify it under the same terms as Perl itself.

=end text

=begin html

Copyright E<copy> 2002-2003 Thomas Stanley. All rights reserved. This program is free software; you can distribute it and/or modify it under the same terms as Perl itself.

=end html

=head1 SEE ALSO

perl(1).

Simran::Log::Log

Simran::Error::Error

=cut
