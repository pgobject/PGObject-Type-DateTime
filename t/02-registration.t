
use Test2::V0;

plan 15;

use PGObject;
use PGObject::Type::DateTime;
use strict;
use warnings;

use Data::Dumper;
no strict 'refs';
diag Dumper(\%{"::PGObject::Type::"});

# Theoretically we could grab ints as well, and this makes a nice test case.
# The tests here are:
# 1.  Registration with the default registry, default types
# 2.  Registration with the default registry, int8 type
# 3.  Registration with custom registry 'test', int8 type
# 4.  Registration with custom registry 'test', default types
# 5.  Registry properly lists all appropriate types.

ok(PGObject::Type::Registry->new_registry('test'), 'creating test registry');

ok(PGObject::Type::DateTime->register(), 'default registration');
ok(PGObject::Type::DateTime->register(types => ['mytime']), 'mytime registration');
ok(PGObject::Type::DateTime->register(registry => 'test', types => ['mytime']),
                               'custom registry, mytime registration'),
ok(PGObject::Type::DateTime->register(registry => 'test'), 
                                'default types, custom registry');
my $registry;
if ($PGObject::VERSION =~ /^1\./){
    $registry = PGObject::get_type_registry();
} else {
    $registry = { map {$_ => PGObject::Type::Registry->inspect($_) } qw(test default) }	;
}
for my $reg(qw(default test)){
    for my $type (qw(date time timestamp timestamptz mytime)) {
        is($registry->{$reg}->{$type}, 'PGObject::Type::DateTime', 
           "registry $reg, type $type correctly registered");
    }
}
