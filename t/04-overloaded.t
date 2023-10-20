#!perl

use PGObject::Type::DateTime;
use Test2::V0;
plan 49;

my $test;

$test = PGObject::Type::DateTime->today;
isa_ok $test, ['DateTime'], 'overloaded today(), isa date time';
isa_ok $test, ['PGObject::Type::DateTime'], 'overloaded today(), is expected class';
like $test->to_db, qr/^\d{4}-\d{2}-\d{2}$/, 'overloaded today() returns a date only';

for my $trunc (qw/ year month week local_week day/) {
    $test = PGObject::Type::DateTime->now->truncate( to => $trunc );
    isa_ok $test, ['DateTime'], 'truncate (no time), isa date time';
    isa_ok $test, ['PGObject::Type::DateTime'], 'truncate (no time), is expected class';
    ok(! $test->is_time, 'truncate (no time), has no time');
}

for my $trunc (qw/ hour minute second /) {
    $test = PGObject::Type::DateTime->now->truncate( to => $trunc );
    isa_ok $test, ['DateTime'], 'truncate (with time), isa date time';
    isa_ok $test, ['PGObject::Type::DateTime'], 'truncate (with time), is expected class';
    ok($test->is_time, 'truncate (with time), has time');
}


$test = PGObject::Type::DateTime->last_day_of_month(year => 2015, month => 12);
isa_ok $test, ['DateTime'], 'last_day_of_month, isa date time';
isa_ok $test, ['PGObject::Type::DateTime'], 'last_day_of_month, is expected class';
ok ! $test->is_time, 'last_day_of_month has no time';


$test = PGObject::Type::DateTime->from_day_of_year(year => 2015,
                                                   day_of_year => 150);
isa_ok $test, ['DateTime'], 'from_day_of_year, isa date time';
isa_ok $test, ['PGObject::Type::DateTime'], 'from_day_of_year, is expected class';
ok ! $test->is_time, 'from_day_of_year has no time';

$test = PGObject::Type::DateTime->inf_future;
isa_ok $test, ['DateTime'], 'Infinite future datetime is DateTime';
isa_ok $test, ['DateTime::Infinite::Future'], 'Infinite future datetime is DateTime::Infinite::Future';
isa_ok $test, ['PGObject::Type::DateTime'], 'Infinite future datetime is PGObject::Type::DateTime';
is $test->to_db, 'infinity', "Infinite future datetime serializes to db as 'infinity'";

$test = PGObject::Type::DateTime->inf_past;
isa_ok $test, ['DateTime'], 'Infinite past datetime is DateTime';
isa_ok $test, ['DateTime::Infinite::Past'], 'Infinite past datetime is DateTime::Infinite::Past';
isa_ok $test, ['PGObject::Type::DateTime'], 'Infinite past datetime is PGObject::Type::DateTime';
is $test->to_db, '-infinity', "Infinite past datetime serializes to db as '-infinity'";

$test = PGObject::Type::DateTime->from_db('infinity');
isa_ok $test, ['DateTime'], 'Infinity is datetime';
isa_ok $test, ['PGObject::Type::DateTime'], 'Infinity is expected class';
isa_ok $test, ['DateTime::Infinite::Future'], 'Infinity is expected infinite class';
is $test->to_db, 'infinity', 'Infinity serializes to db as infinity';

$test =  PGObject::Type::DateTime->from_db('-infinity');
isa_ok $test, ['DateTime'], '-Infinity is datetime';
isa_ok $test, ['PGObject::Type::DateTime'], '-Infinity is expected class';
isa_ok $test, ['DateTime::Infinite::Past'], '-Infinity is expected infinite class';
is $test->to_db, '-infinity', '-Infinity serializes to db as -infinity';

