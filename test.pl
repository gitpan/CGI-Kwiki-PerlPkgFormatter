#!/usr/local/bin/perl -w

use Test::More 'no_plan';

package Catch;

sub TIEHANDLE {
    my($class, $var) = @_;
    return bless { var => $var }, $class;
}

sub PRINT  {
    my($self) = shift;
    ${'main::'.$self->{var}} .= join '', @_;
}

sub OPEN  {}    # XXX Hackery in case the user redirects
sub CLOSE {}    # XXX STDERR/STDOUT.  This is not the behavior we want.

sub READ {}
sub READLINE {}
sub GETC {}

my $Original_File = 'PerlPkgFormatter.pm';

package main;

# pre-5.8.0's warns aren't caught by a tied STDERR.
$SIG{__WARN__} = sub { $main::_STDERR_ .= join '', @_; };
tie *STDOUT, 'Catch', '_STDOUT_' or die $!;
tie *STDERR, 'Catch', '_STDERR_' or die $!;

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 51 PerlPkgFormatter.pm
use Test::More;
use_ok('CGI::Kwiki::PerlPkgFormatter');
is( $CGI::Kwiki::PerlPkgFormatter::VERSION, '0.0.2',
    'tests running against correct version of module');

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 73 PerlPkgFormatter.pm

my @orig_process_order = CGI::Kwiki::Formatter->process_order();
my @new_process_order = CGI::Kwiki::PerlPkgFormatter->process_order();
is( @new_process_order, @orig_process_order + 2,
    'PerlPkgFormatter adds two entries to process_order');


    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 98 PerlPkgFormatter.pm

my $expected = qr|^FooBar::Baz$|;
my $in = "!{FooBar::Baz}";
my $out = CGI::Kwiki::PerlPkgFormatter->combine_chunks(
 CGI::Kwiki::PerlPkgFormatter->dispatch( [ $in ], 'no_perlpkg_wiki_link') );
like( $out, $expected, 'marked package name is not turned into a link');
    

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

{
    undef $main::_STDOUT_;
    undef $main::_STDERR_;
#line 121 PerlPkgFormatter.pm

my $expected = qr|<a href="\?page_id=FooBar::Baz">FooBar::Baz</a>|;
my $in = "[{FooBar::Baz}]";
my $out = CGI::Kwiki::PerlPkgFormatter->combine_chunks(
 CGI::Kwiki::PerlPkgFormatter->dispatch( [ $in ], 'perlpkg_wiki_link') );
like( $out, $expected, 'marked package name is turned into a link');
    

    undef $main::_STDOUT_;
    undef $main::_STDERR_;
}

