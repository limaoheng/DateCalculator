# DateCalculator

====================================

## Features

* Calculating certain things between two dates, ie, days, weeks

## SYNOPSIS

perl calculate_date.pl --dates="2015-01-18" --dates="2016-12-31" --unit=day --timezones="Australia/Sydney" --timezones="Australia/Adelaide"

## OPTIONS

### --dates        
Mandatory. The format should be following ISO8601, which is
yyyy-mm-ddThh:mm:ss. The limitation here is due to the DateTime module in Perl uses
normal integer when does the math, and this caused certain range of the two dates can
go.

### --timezones    
Optional. The valid timezones can be found in 
https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.

### --valid-timezone   
Optional. Show all valid timezones.

### --unit   
Optional. This will convert the duration between two dates into desired
result. Valid units are:
'year'
'day'
'hour'
'minute'
'second'
