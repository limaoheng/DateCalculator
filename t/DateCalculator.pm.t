#!/usr/bin/perl

use strict;
use warnings;

# CPAN
use Test::More;
use Test::Differences;
use Test::Exception;
use DateTime;

# Custom
use DateCalculator;

sub main {
    subtest "getAbosulteDuration" => sub {
        subtest "same date" => sub {

            my $date1 = DateTime->new(
                year        => "2018",
                month       => "07",
                day         => "07"
            );

            my $date2 = DateTime->new(
                year        => "2018",
                month       => "07",
                day         => "07"
            );

            my $expect = 0;

            my $actual = DateCalculator::getAbosulteDuration({
                date1 => $date1, 
                date2 => $date2
            });

            eq_or_diff($actual, $expect, "Test same date.");
            
            done_testing();
        };
        
        subtest "Test two dates" => sub {
            my $date1 = DateTime->new(
                year        => "2018",
                month       => "01",
                day         => "01"
            );

            my $date2 = DateTime->new(
                year        => "2017",
                month       => "12",
                day         => "31"
            );

            # This is one day in second.
            my $expect = 86400;

            my $actual = DateCalculator::getAbosulteDuration({
                date1 => $date1, 
                date2 => $date2
            });

            # Test absolute value
            eq_or_diff($actual, $expect, "Test date1 larger than date2.");

            $actual = DateCalculator::getAbosulteDuration({
                date2 => $date1, 
                date1 => $date2
            });
            eq_or_diff($actual, $expect, "Test date2 larger than date1.");

            done_testing();
        };
        done_testing();
    };

    subtest "getAbsoluteWorkdays" => sub {
        subtest "same date" => sub {

            my $date1 = DateTime->new(
                year        => "2018",
                month       => "07",
                day         => "07"
            );

            my $date2 = DateTime->new(
                year        => "2018",
                month       => "07",
                day         => "07"
            );

            my $expect = 0;

            my $actual = DateCalculator::getAbsoluteWorkdays({
                date1 => $date1, 
                date2 => $date2
            });

            eq_or_diff($actual, $expect, "Test same date.");
            
            done_testing();
        };
        
        subtest "Test two dates" => sub {
            my $date1 = DateTime->new(
                year        => "2018",
                month       => "01",
                day         => "01"
            );

            my $date2 = DateTime->new(
                year        => "2017",
                month       => "12",
                day         => "31"
            );

            # This is one day in second.
            my $expect = 1;

            my $actual = DateCalculator::getAbsoluteWorkdays({
                date1 => $date1, 
                date2 => $date2
            });

            # Test absolute value
            eq_or_diff($actual, $expect, "Test date1 larger than date2.");

            $actual = DateCalculator::getAbsoluteWorkdays({
                date2 => $date1, 
                date1 => $date2
            });
            eq_or_diff($actual, $expect, "Test date2 larger than date1.");

            done_testing();
        };

        done_testing();
    };

    subtest "convertSecondsInto" => sub {
        subtest "convert second" => sub {

            my $seconds = 86400;

            my $expect = 1;

            my $actual = DateCalculator::convertSecondsInto({
                seconds   => $seconds, 
                unit    => 'day'
            });

            eq_or_diff($actual, $expect, "Test convert to day.");
            
            $expect = 24;

            $actual = DateCalculator::convertSecondsInto({
                seconds   => $seconds, 
                unit    => 'hour'
            });
            
            eq_or_diff($actual, $expect, "Test convert to hour.");

            $expect = 24 * 60;

            $actual = DateCalculator::convertSecondsInto({
                seconds   => $seconds, 
                unit    => 'minute'
            });
            
            eq_or_diff($actual, $expect, "Test convert to minute.");

            $expect = $seconds / (3600 * 24 * 365);

            $actual = DateCalculator::convertSecondsInto({
                seconds   => $seconds, 
                unit    => 'year'
            });
            
            eq_or_diff($actual, $expect, "Test convert to year.");


            done_testing();
        };

        done_testing();
    };
}

main();
done_testing();
