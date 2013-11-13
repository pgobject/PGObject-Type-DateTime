package PGObject::Type::DateTime;

use 5.006;
use strict;
use warnings;
use base qw(DateTime);

=head1 NAME

PGObject::Type::DateTime - DateTime Wrappers for PGObject

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

   PGObject::Type::DateTime->register();

Now all Datetime, Timestamp, and TimestampTZ types are returned 
returned as datetime objects.  Date and time modules may require subclasses
to serialize properly to the database.

=head1 DESCRIPTION

This module provides a basic wrapper around DateTime to allow PGObject-framework
types to automatically tie date/time related objects, but we handle date and
timestamp formats in our from_db routines.

=head1 SUBROUTINES/METHODS

=head2 register

By default registers 'datetime', 'timestamp', and 'timestamptz'

=cut

sub register {
}

=head2 from_db

=cut

sub from_db {
}

=head2 to_db

=cut

sub to_db {
}

=head1 AUTHOR

Chris Travers, C<< <chris.travers at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-pgobject-type-datetime at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=PGObject-Type-DateTime>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc PGObject::Type::DateTime


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=PGObject-Type-DateTime>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/PGObject-Type-DateTime>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/PGObject-Type-DateTime>

=item * Search CPAN

L<http://search.cpan.org/dist/PGObject-Type-DateTime/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Chris Travers.

This program is released under the following license: BSD


=cut

1; # End of PGObject::Type::DateTime
