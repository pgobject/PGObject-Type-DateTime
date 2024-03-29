use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'PGObject::Type::DateTime',
    AUTHOR              => q{Chris Travers <chris.travers@gmail.com>},
    VERSION_FROM        => 'lib/PGObject/Type/DateTime.pm',
    ABSTRACT_FROM       => 'lib/PGObject/Type/DateTime.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'BSD')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'PGObject' => '2.0',
	'DateTime' => '1.05', # 'local_week' was added in 1.05
	'DateTime::TimeZone' => 0,
    },
    BUILD_REQUIRES => {
        'Test2::V0' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'PGObject-Type-DateTime-*' },
    META_MERGE => {
        'meta-spec' => { version => 2 },
         resources => {
             repository => {
                 type => 'git',
                 url  => 'https://github.com/ledgersmb/PGObject-Type-DateTime.git',
                 web  => 'https://github.com/ledgersmb/PGObject-Type-DateTime',
             },
         },
    },
);
