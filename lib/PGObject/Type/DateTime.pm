package PGObject::Type::DateTime;

use 5.006;
use Carp;
use strict;
use warnings;
use base qw(DateTime);
use DateTime::TimeZone;

=head1 NAME

PGObject::Type::DateTime - DateTime Wrappers for PGObject

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
our $default_tz = DateTime::TimeZone->new(name => 'UTC');


=head1 SYNOPSIS

   PGObject::Type::DateTime->register();

Now all Datetime, Timestamp, and TimestampTZ types are returned 
returned as datetime objects.  Date and time modules may require subclasses
to serialize properly to the database.

=head1 DESCRIPTION

This module provides a basic wrapper around DateTime to allow PGObject-framework
types to automatically tie date/time related objects, but we handle date and
timestamp formats in our from_db routines.

This specific module only supports the ISO YMD datestyle.  The MDY or DMY 
datestyles may be usable in future versions but datestyles other than ISO raise
ambiguity issues, sufficient that they cannot always even be used in PostgreSQL as input.

This module also provides basic default handling.  Times are assigned a date of
'0001-01-01' and dates are assigned a time of midnight.  Whether this is set is
persisted, along with whether timezones are set, and these are returned to a 
valid ISO YMD format on export, if a date component was initially set.

This means you can use this for general math without worrying about many of the
other nicities.  Parsing ISO YMD dates and standard times (24 hr format) is 
supported via the from_db interface, which also provides a useful way of handing
dates in.

=head1 SUBROUTINES/METHODS

=head2 register

By default registers 'date', 'time', 'timestamp', and 'timestamptz'

=cut

sub register {
    my $self = shift @_;
    croak "Can't pass reference to register \n".
          "Hint: use the class instead of the object" if ref $self;
    my %args = @_;
    my $registry = $args{registry};
    $registry ||= 'default';
    my $types = $args{types};
    $types = ['date', 'time', 'timestamp', 'timestamptz'] 
           unless defined $types and @$types;
    for my $type (@$types){
        my $ret = 
            PGObject->register_type(registry => $registry, pg_type => $type,
                                  perl_class => $self);
        return $ret unless $ret;
    }
    return 1;
}

=head2 from_db

Parses a date from YYYY-MM-DD format and generates the new object based on it.

=cut

sub from_db {
    my ($class, $value) = @_;
    my ($year, $month, $day, $hour, $min, $sec, $nanosec, $tz);
    $value =~ /(\d{4})-(\d{2})-(\d{2})/ 
          and ($year, $month, $day) = ($1, $2, $3);
    $value =~ /(\d+):(\d+):([0-9.]+)([+-]\d+)?/ 
          and ($hour, $min, $sec, $tz) = ($1, $2, $3, $4);
    $tz ||= $default_tz; # defaults to UTC
    $tz .= '00' if $tz =~ /([+-]\d{2}$)/;
    ($sec, $nanosec) = split /\./, $sec if $sec;
    $nanosec *= 1000 if $nanosec; # no need to worry about truth here
                                # since 0 * anything is.... --CT
    $nanosec ||= 0;
    my %args = ();
    $args{year} = ($year || 1);
    $args{month} = ($month || 1);
    $args{day} = ($day || 1);
    $args{hour} = ($hour || 0);
    $args{minute} = ($min || 0);
    $args{second} = ($sec || 0);
    $args{nanosecond} = ($nanosec || 0);
    $args{time_zone} = $tz;
    my $self = __PACKAGE__->new(%args);
    $self->{_pgobject_is_date} = 1 if $year;
    $self->{_pgobject_is_time} = 1 if defined $hour;
    return $self;
}

=head2 to_db

Returns the date in YYYY-MM-DD format.

=cut

sub to_db {
    my ($self) = @_;
    my $dbst = '';
    my $offset = $self->offset;
    $offset = $offset / 60;
    my $offset_min = $offset%60;
    $offset = $offset / 60;
    my $sign = ($offset > 0)? '+' : '-';
    $offset = $sign . sprintf('%02d', abs($offset));

    if ($offset_min){
       $offset = "$offset$offset_min";
    }

    $dbst .= $self->ymd if $self->is_date;
    $dbst .= ' ' if $self->is_date and $self->is_time;
    $dbst .= $self->hms . '.' . $self->microsecond if $self->is_time;
    $dbst .= $offset if $self->time_zone ne $default_tz and $self->is_time;
    return $dbst;
}

=head2 is_date($to_set)

If $to_set is set, sets this.  In both cases, returns whether the object is now
a date.

=cut

sub is_date {
    my ($self, $val) = @_;
    if (defined $val){
       $self->{_pgobject_is_date} = $val;
    }
    return $self->{_pgobject_is_date};
}

=head2 is_time($to_set)

If $to_set is set, sets this.  In both cases, returns whether the object is now
a time.

=cut


sub is_time {
    my ($self, $val) = @_;
    if (defined $val){
       $self->{_pgobject_is_time} = $val;
    }
    return $self->{_pgobject_is_time};
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
