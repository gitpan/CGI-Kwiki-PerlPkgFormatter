use 5.005;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		    => 'CGI::Kwiki::PerlPkgFormatter',
    'VERSION_FROM'	=> 'PerlPkgFormatter.pm',
    'PREREQ_PM'		=> {
        'Test::More'            => undef,
        'CGI::Kwiki::Formatter' => undef,
    },
    ABSTRACT_FROM   => 'PerlPkgFormatter.pm',
    AUTHOR          => 'James FitzGibbon <JFITZ@cpan.org>',
);
