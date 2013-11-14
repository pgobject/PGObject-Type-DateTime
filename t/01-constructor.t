use PGObject::Type::DateTime;
use Test::More tests => 15;

my $test;

$test = PGObject::Type::DateTime->from_db("2013-12-11 11:11:11.11234-08");
isa_ok $test, 'DateTime', 'long parse, isa date time';
isa_ok $test, 'PGObject::Type::DateTime', 'long parse, is expected class';
is $test->to_db, "2013-12-11 11:11:11.11234-08", 'long parse, expected db out';

$test = PGObject::Type::DateTime->from_db('2012-12-11'); 
isa_ok $test, 'DateTime', 'date only, isa date time';
isa_ok $test, 'PGObject::Type::DateTime', 'date only, is expected class';
is $test->to_db, "2012-12-11", 'date only, expected db out';

$test = PGObject::Type::DateTime->from_db('11:11:23.1111');
isa_ok $test, 'DateTime', 'time only, isa date time';
isa_ok $test, 'PGObject::Type::DateTime', 'time only, is expected class';
is $test->to_db, "11:11:23.1111", 'long parse, expected db out';

$test = PGObject::Type::DateTime->from_db("2013-12-11 00:00:00.0000-08");
isa_ok $test, 'DateTime', 'Midnight, isa date time';
isa_ok $test, 'PGObject::Type::DateTime', 'Midnight. is expected class';
is $test->to_db, "2013-12-11 00:00:00.0-08", 'Midnight, expected db out';

$test = PGObject::Type::DateTime->from_db("2013-12-11 00:00:00.0000+08");
isa_ok $test, 'DateTime', 'Midnight, positive offset, isa date time';
isa_ok $test, 'PGObject::Type::DateTime', 'Midnight positive offset. is expected class';
is $test->to_db, "2013-12-11 00:00:00.0+08", 'Midnight positive offset, expected db out';



