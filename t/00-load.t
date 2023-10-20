#!perl -T

use Test2::V0;

plan 2;

BEGIN {
    ok ( eval 'require PGObject::Type::DateTime' ) || print "Bail out!\n";
    ok ( eval 'require PGObject::Type::DateTime::Infinite' ) || print "Bail out!\n";
}

diag( "Testing PGObject::Type::DateTime $PGObject::Type::DateTime::VERSION, Perl $], $^X" );
