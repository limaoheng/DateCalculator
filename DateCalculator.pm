
=head1 NAME

DateCalculator

=head1 DESCRIPTION

Util class for calculating stuff among dates.

=cut

######################################################################
## Package Information

package DateCalculator;

######################################################################
## Imports

use strict;
use warnings;

use Carp qw(confess);
use Params::Check;
use Date::Calendar;
use Date::Calendar::Profiles qw($Profiles);
use Readonly;
use Math::BigInt;

######################################################################
## Constants

Readonly our $VALID_UNIT_CONVERSION_RULES => {
    'year'      => 31536000,
    'day'       => 86400,
    'hour'      => 3600,
    'minute'    => 60,
    'second'    => 1
};

=head2 getAbosulteDuration

=head3 DESCRIPTION

Get the absolute value of duration in seconds between 2 dates.

=head3 PARAMETERS

    - date1: Required. DateTime Obj.
    - date2: Required. DateTime Obj.

=cut

sub getAbosulteDuration {
    my $param = shift;

    my $dt1;
    my $dt2;

    # Input validation
    my $template = { 
        date1 => { required => 1, defined => 1, store => \$dt1 },
        date2 => { required => 1, defined => 1, store => \$dt2 },
    };
    $param = Params::Check::check( $template, $param );
    if ( Params::Check::last_error() ) {
        confess "Input validation failed: " . Params::Check::last_error() . ", stopped";
    }

    return $dt2->subtract_datetime_absolute($dt1)->seconds;
}

=head2 getAbsoluteWorkdays

=head3 DESCRIPTION

Get the absolute value of work days between two dates

=head3 PARAMETERS

    - date1: Required. DateTime Obj.
    - date2: Required. DateTime Obj.

=cut


sub getAbsoluteWorkdays {

    my $param = shift;

    my $dt1;
    my $dt2;

    # Input validation
    my $template = { 
        date1 => { required => 1, defined => 1, store => \$dt1 },
        date2 => { required => 1, defined => 1, store => \$dt2 },
    };
    $param = Params::Check::check( $template, $param );
    if ( Params::Check::last_error() ) {
        confess "Input validation failed: " . Params::Check::last_error() . ", stopped";
    }

    my $calendar = Date::Calendar->new($Profiles->{'AU'});
    return abs $calendar->delta_workdays(
        $dt1->year, $dt1->month, $dt1->day,
        $dt2->year, $dt2->month, $dt2->day, 
        1, 1);
}

=head2 convertSecondsInto

=head3 DESCRIPTION

Convert given seconds into different presentation. 

=head3 PARAMETERS

    - seconds   : Required. 
    - unit      : Required. 

=cut


sub convertSecondsInto {

    my $param = shift;

    my $seconds;
    my $unit;

    # Input validation
    my $template = { 
        seconds => { required => 1, defined => 1, store => \$seconds },
        unit    => { required => 1, defined => 1, store => \$unit},
    };
    $param = Params::Check::check( $template, $param );
    if ( Params::Check::last_error() ) {
        confess "Input validation failed: " . Params::Check::last_error() . ", stopped";
    }
    confess "Can't determine unit given $unit. " unless $VALID_UNIT_CONVERSION_RULES->{$unit};

    return $seconds / $VALID_UNIT_CONVERSION_RULES->{$unit};

}

1;