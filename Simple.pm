package Logger::Simple;
use strict;
use Carp;
use FileHandle;
use vars qw /$VERSION/;

$VERSION='1.0';

sub new{
  my($class,%args)=@_;
  my $self =  bless{LOG        => $args{LOG} || croak"No logfile!\n",
                    CARP       => $args{CARP} || undef,
                    FILEHANDLE => new FileHandle,
                    ERROR      => "",
                    HISTORY    => [],
              },$class;

  if(! $self->open()){
    $self->set("Could not open logfile $$self{LOG} for writing");
  }

  return $self;
}

sub open{
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

  if(! print $FH "$format\n"){
    $self->set("Unable to write to $$self{LOG}: $!\n");
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
}

sub print_object{
  require Data::Dumper;
  my $self=shift;
  print Data::Dumper->Dumper($self);  
}

1;
__END__

=head1 NAME

Logger::Simple - Implementation of the Simran-Log-Log and Simran-Error-Error modules

=head1 SYNOPSIS

  use Logger::Simple;
  my $log=Logger::Simple->new({LOG=>"/tmp/program.log",CARP=>'1'});
  my $x=5;my $y=4;
  if($x>$y){
    # Set an error message
    $log->set("\$x is greater than \$y");

    # Write a message to the log file 
    $log->write("\$x is greater than \$y");
  }
  $log->set("Another error message");

  # Get entire Error Message History
  my @msgs = $log->message;
  foreach my $m(@msgs){
    print "Message: $m\n";
  }

  # Get the last set error message
  my $message=$log->message;
  print "Message: $message\n";
  
=head1 DESCRIPTION

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

Thomas Stanley <Thomas_J_Stanley@msn.com>

=head1 COPYRIGHT

Copyright (C) 2002 Thomas Stanley. All rights reserved. This program is free
software; you can distribute it and/or modify it under the same terms as
Perl itself.

=head1 SEE ALSO

perl(1).

=cut
