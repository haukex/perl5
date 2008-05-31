#!/usr/bin/perl -w

BEGIN {
    if( $ENV{PERL_CORE} ) {
        chdir 't';
        @INC = '../lib';
    }
}

use strict;
use warnings;


my $have_perlio;
BEGIN {
    # All together so Test::More sees the open discipline
    $have_perlio = eval q[
        use PerlIO;
        use open ':std', ':locale';
        use Test::More;
        1;
    ];
}
#use Test::More tests => 5;
use Test::More skip_all => 'Not yet implemented';

SKIP: {
    skip( "Need PerlIO for this feature", 3 )
        unless $have_perlio;

    my %handles = (
        output          => \*STDOUT,
        failure_output  => \*STDERR,
        todo_output     => \*STDOUT
    );

    for my $method (keys %handles) {
        my $src = $handles{$method};
        
        my $dest = Test::More->builder->$method;
        
        is_deeply [PerlIO::get_layers($dest)],
                  [PerlIO::get_layers($src)],
                  "layers copied to $method";
    }
}

SKIP: {
    skip( "Can't test in general because their locale is unknown", 2 )
        unless $ENV{AUTHOR_TESTING};

    my $uni = "\x{11e}";
    
    my @warnings;
    local $SIG{__WARN__} = sub {
        push @warnings, @_;
    };

    is( $uni, $uni, "Testing $uni" );
    is_deeply( \@warnings, [] );
}