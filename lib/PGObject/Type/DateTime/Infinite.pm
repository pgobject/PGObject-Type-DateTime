=head1 NAME

   PGObject::Util::Type::DateTime::Infinite -- Infinite Date Times in PGObject

=head1 VERSION

   2.1.1

=head1 SYNOPSIS

   # for a timestamp infinitely far in the future
   my $future = PGObject::Util::Type::DateTime::Infinite::Future->new

   # or infinitely far in the past

   my $past = PGObject::Util::Type::DateTime::Infinite::Past->new

=cut

# This package doesn't do anything, just there for loading
# and to make sure other modules are loaded since the modules
# we subclass are found in DateTime::Infinite's perl module

package PGObject::Util::Type::DateTime::Infinite;
use DateTime::Infinite; # loads the classes we will be using.
use strict;
use warnings;

=head1 DESCRIPTION

PostgreSQL supports timestamps of 'infinity' (can also be written '+infinity')
and '-infinity' and it turns out Perl has support for the same.  So this module
implements a bridge between PGObject and this functionality.

=head1 SUBCLASSES

This module offers two subclasses for future and past.

=head2 PGObject::Util::Type::DateTime::Infinite::Future

This class +infinity and infinity to DateTime::Infinite::Future objects

=head2 PGObject::Util::Type::DateTime::Infinite::Past

This class maps -infinity to DateTime::Infinite::Past objects.

=cut

package PGObject::Type::DateTime::Infinite::Future;
use parent -norequire, qw(DateTime::Infinite::Future PGObject::Type::DateTime);
use strict;
use warnings;

sub new {
    my $class = shift;
    my $val = DateTime::Infinite::Future->new;
    bless $val, ($class // __PACKAGE__);
}

sub to_db { 'infinity' }

package PGObject::Type::DateTime::Infinite::Past;
use parent -norequire, qw(DateTime::Infinite::Past PGObject::Type::DateTime);
use strict;
use warnings;

sub new {
    my $class = shift;
    my $val = DateTime::Infinite::Past->new;
    bless $val, ($class // __PACKAGE__);
}

sub to_db { '-infinity' }

=head1 SEE ALSO

=over

=item DateTime::Infinite

=item DateTime

=item PGObject::Type::DateTime

=back

=head1 COPYING

See the terms of PGObject::Type::DateTime for the license agreement as this
is part of that package.

=cut

1;

