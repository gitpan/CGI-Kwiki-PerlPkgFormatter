=head1 NAME

CGI::Kwiki::PerlPkgFormatter - format Perl package names as kwiki links

=head1 SYNOPSIS

In the kwiki's config file:

 formatter_class: CGI::Kwiki::PerlPkgFormatter

In the source of a kwiki page:

 [{CGI::Kwiki::PerlPkgFormatter}] will become a link
 !{CGI::Kwiki::PerlPkgFormatter} will not become a link

=head1 DESCRIPTION

CGI::Kwiki::PerlPkgFormatter extends CGI::Kwiki::Formatter to make it easier
to create kwiki links out of Perl package names.

The default kwiki markup would take the following source:

 * CGI::Kwiki::PerlPkgFormatter
 * [CGI::Kwiki::PerlPkgFormatter]
 * !CGI::Kwiki::PerlPkgFormatter
 
and output the following HTML:

 <ul>
 <li>CGI::Kwiki::<a href="?PerlPkgFormatter">PerlPkgFormatter</a>
 <li>[CGI::Kwiki::<a href="?PerlPkgFormatter">PerlPkgFormatter</a>]
 <li>!CGI::Kwiki::<a href="?PerlPkgFormatter">PerlPkgFormatter</a>
 </ul>

None of which are links to a page named after the package.

Using CGI::Kwiki::PerlPkgFormatter, the following source:

 * [{CGI::Kwiki::PerlPkgFormatter}]
 * !{CGI::Kwiki::PerlPkgFormatter}

produces the correct HTML markup:

 <ul>
 <li><a href="?page_id=CGI::Kwiki::PerlPkgFormatter">
 CGI::Kwiki::PerlPkgFormatter</a>
 <li>CGI::Kwiki::PerlPkgFormatter
 </ul>

=for testing
use Test::More;
use_ok('CGI::Kwiki::PerlPkgFormatter');
is( $CGI::Kwiki::PerlPkgFormatter::VERSION, '0.0.3',
    'tests running against correct version of module');
 
=cut

package CGI::Kwiki::PerlPkgFormatter;

$VERSION = '0.0.3';

use 5.005;  # for qr// and constant
use strict;
use warnings;

use CGI::Kwiki::Formatter;
use base 'CGI::Kwiki::Formatter';

use constant    PACKAGE_LINK   => qr/\[{([\w:]+)}\]/;
use constant NO_PACKAGE_LINK   => qr/!{([\w:]+)}/;

=pod

=begin testing

my @orig_process_order = CGI::Kwiki::Formatter->process_order();
my @new_process_order = CGI::Kwiki::PerlPkgFormatter->process_order();
is( @new_process_order, @orig_process_order + 2,
    'PerlPkgFormatter adds two entries to process_order');

=end testing

=cut

sub process_order {
    my $self = shift;
    # this might break if the default process order in CGI::Kwiki::Formatter
    # ever changes
    return map
    { m/no_wiki_link/
      ? ( 'no_perlpkg_wiki_link', 'perlpkg_wiki_link', $_ )
      : $_
    }   
    $self->SUPER::process_order;
}

=pod

=begin testing

my $expected = qr|^FooBar::Baz$|;
my $in = "!{FooBar::Baz}";
my $out = CGI::Kwiki::PerlPkgFormatter->combine_chunks(
 CGI::Kwiki::PerlPkgFormatter->dispatch( [ $in ], 'no_perlpkg_wiki_link') );
like( $out, $expected, 'marked package name is not turned into a link');
    
=end testing

=cut

sub no_perlpkg_wiki_link
{
    my($self, $text) = @_;
    $self->split_method($text,
        NO_PACKAGE_LINK,
        'no_wiki_link_format',
    );
}

=pod

=begin testing

my $expected = qr|<a href="\?page_id=FooBar::Baz">FooBar::Baz</a>|;
my $in = "[{FooBar::Baz}]";
my $out = CGI::Kwiki::PerlPkgFormatter->combine_chunks(
 CGI::Kwiki::PerlPkgFormatter->dispatch( [ $in ], 'perlpkg_wiki_link') );
like( $out, $expected, 'marked package name is turned into a link');
    
=end testing

=cut

sub perlpkg_wiki_link
{
    my($self, $text) = @_;
    $self->split_method($text,
        PACKAGE_LINK,
        'wiki_perlpkg_link_format',
    );
}

sub wiki_perlpkg_link_format
{
    my($self, $text) = @_;
    return qq{<a href="?page_id=$text">$text</a>};
}

# keep require happy
1;

__END__

=head1 SEE ALSO 

L<CGI::Kwiki>, the KwikiFormattingRules page of an installed kwiki.

=head1 AUTHOR 

James FitzGibbon <JFITZ@cpan.org>

=head1 COPYRIGHT 

Copyright (c) 2003, James FitzGibbon.  All rights reserved. 

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. 

See http://www.perl.com/perl/misc/Artistic.html 

=cut

#
# EOF
