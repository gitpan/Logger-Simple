use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Logger::Simple',
    'VERSION_FROM'	=> 'Simple.pm', # finds $VERSION
    'PREREQ_PM'		=> {Carp => 0,
                            FileHandle => 0,
                            Data::Dumper => 0,
                            }, # e.g., Module::Name => 1.1
);
