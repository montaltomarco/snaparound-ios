//
//  RelativeTime.m
//  RelativeTime
//
//  Created by Karim Benhmida on 15/06/2014.
//

#import "RelativeTime.h"

@implementation RelativeTime

+ (NSString*)stringFromDate:(NSDate*) date {
    
    unsigned long long difference = [RelativeTime differenceInMinutes:date];
    
    if (difference < 1) {
        return NSLocalizedString(@"NOW",nil);
    }
    else if (difference >= 1 && difference < 2) {
        return NSLocalizedString(@"ONE_MINUTE_AGO",nil);
    }
    else if (difference >= 2 && difference < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"X_MINUTES_AGO",nil), difference];
    }
    else if (difference >= 60 && difference < 60*2) {
        return NSLocalizedString(@"ONE_HOUR_AGO",nil);
    }
    else if (difference >= 60 && difference <= 24*60) {
        return [NSString stringWithFormat:NSLocalizedString(@"X_HOURS_AGO",nil), (int)(difference/60)];
    }
    else if (difference >= 24*60 && difference < 24*60*2) {
        return NSLocalizedString(@"ONE_DAY_AGO",nil);
    }
    else if (difference >= 24*60*2 && difference <= 24*60*31) {
        return [NSString stringWithFormat:NSLocalizedString(@"X_DAYS_AGO",nil), (int)(difference/(60*24))];
    }
    else if (difference >= 24*60*31 && difference <= 24*60*31*2) {
        return NSLocalizedString(@"ONE_MONTH_AGO",nil);
    }
    else if (difference >= 24*60*31*2 && difference <= 24*60*365) {
        return [NSString stringWithFormat:NSLocalizedString(@"X_MONTH_AGO",nil), (int)(difference/(60*24*30.5))];
    }
    else if (difference >= 24*60*365 && difference < 24*60*365*2) {
        return NSLocalizedString(@"ONE_YEAR_AGO",nil);
    }
    else {
        return [NSString stringWithFormat:NSLocalizedString(@"X_YEARS_AGO",nil), (int)(difference/(60*24*365))];
    }
}

// This method gives the difference between the current date and the date give in parameter in minutes
+ (unsigned long long)differenceInMinutes:(NSDate*) date {
    
    return (unsigned long long)(ABS([date timeIntervalSinceNow]/60));
    
}

+ (NSDate *)beginningOfDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)beginningOfWeek:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    
    [components setWeekday:2];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)beginningOfMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
}

@end
