#!/usr/bin/perl

use strict;
use warnings;
use utf8;

=head1 NAME

calculate_date - This is for calculating certain things between two dates.

=head1 DESCRIPTION

The script will calculate number of days, weekdays and complete weeks for given two
dates.

=head1 SYNOPSIS

perl calculate_date.pl --dates="2015-01-18" --dates="2016-12-31" --unit=day --timezones="Australia/Sydney" --timezones="Australia/Adelaide"

=head1 OPTIONS

=over

=item B<--dates>        Mandatory. The format should be following ISO8601, which is
yyyy-mm-ddThh:mm:ss. The limitation here is due to the DateTime module in Perl uses
normal integer when does the math, and this caused certain range of the two dates can
go.

=item B<--timezones>    Optional. The valid timezones can be found in 
https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.

=item B<--valid-timezone>   Optional. Show all valid timezones.

=item B<--unit>   Optional. This will convert the duration between two dates into desired
result. Valid units are:
'year'
'day'
'hour'
'minute'
'second'

=cut

######################################################################
# CPAN
use Carp qw(carp confess croak);
use Data::Dumper;
use Pod::Usage;
use DateTime;
use DateTime::TimeZone;
use Getopt::Long qw(:config auto_version);

######################################################################
# Customized
use DateCalculator;

MAIN: {

    my @dates;
    my @timezones;
    my $unit;
    my $show_valid_timezone;

    Getopt::Long::GetOptions(
        "dates=s"           => \@dates,
        "timezones=s"       => \@timezones,
        "unit=s"            => \$unit,
        "valid-timezone"    => \$show_valid_timezone,
    ) or pod2usage ( -verbose => 1 );

    if ($show_valid_timezone) {
        print join "\n", DateTime::TimeZone->all_names;
        exit;
    }

    # Let's do some input check first.
    if (scalar @dates != 2) {
        logError("Please provide 2 dates in required format.");
    }
    
    $unit = $unit ? lc $unit : 'day';
    logError("Please specify unit among following values\n" . Data::Dumper::Dumper(keys %$DateCalculator::VALID_UNIT_CONVERSION_RULES)) 
        unless $DateCalculator::VALID_UNIT_CONVERSION_RULES->{$unit};

    my @date_objs;

    for (my $i = 0; $i < scalar @dates; $i++) {
        my $date = $dates[$i];

        my($year, $month, $day, $hour, $minute, $second) = 
            $date =~ /^(\d{4})-(\d{2})-(\d{2})(?:T(\d{2}):(\d{2}):(\d{2}))?$/;

        # Let's check Timezone as well
        my $timezone = $timezones[$i] || 'local';

        # Create DateTime obj
        eval {
            my $date_obj = DateTime->new(
                year        => $year,
                month       => $month,
                day         => $day,
                hour        => $hour || 0,
                minute      => $minute || 0,
                second      => $second || 0,
                time_zone   => $timezone,
            );
            push @date_objs, $date_obj;
            1;
        } or do {
            logError("Creation of date failed. Please follow ISO8601 standard. \nError details: $@");
        };
    }

    my $duration_seconds = DateCalculator::getAbosulteDuration({
        date1 => $date_objs[0], 
        date2 => $date_objs[1]
    });

    my $delta_workdays = DateCalculator::getAbsoluteWorkdays({
        date1 => $date_objs[0], 
        date2 => $date_objs[1]
    });

    my $converted_duration = DateCalculator::convertSecondsInto({
        seconds => $duration_seconds,
        unit    => lc $unit || 'day'
    });
    
    print "Duration in $unit: $converted_duration\n";
    print "Weekday number: $delta_workdays\n";
}

sub logError {
    my $message = shift;
    pod2usage(-verbose => 1, -message => "Error: $message\n");
    exit;
}