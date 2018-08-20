//
//  WTDateUtil.m
//  Autohome
//
//  Created by autohome on 15/5/28.
//  Copyright (c) 2015年 autohome. All rights reserved.
//

#define NSGregorianCalendar             NSCalendarIdentifierGregorian
#define NSYearCalendarUnit              NSCalendarUnitYear
#define NSMonthCalendarUnit             NSCalendarUnitMonth
#define NSDayCalendarUnit               NSCalendarUnitDay
#define NSWeekCalendarUnit              NSCalendarUnitWeekOfYear
#define NSHourCalendarUnit              NSCalendarUnitHour
#define NSMinuteCalendarUnit            NSCalendarUnitMinute
#define NSSecondCalendarUnit            NSCalendarUnitSecond
#define NSWeekdayCalendarUnit           NSCalendarUnitWeekday
#define NSWeekdayOrdinalCalendarUnit    NSCalendarUnitWeekdayOrdinal
 
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

#import "WTDateUtil.h"

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

#define WT_DATE_Format @"yyyy-MM-dd"
#define WT_TIME_Format @"HH:mm:ss"

@implementation NSDate (WTDateUtil)

#pragma mark Relative Dates

+ (NSInteger)daysOfMonth:(NSInteger)month ofYear:(NSInteger)year{
    NSInteger days;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            days = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            days = 30;
            break;
        case 2:{
            if((year % 4==0 && year % 100!=0) || year % 400==0)
                days = 29;
            else
                days = 28;
            break;
        }
        default:
            days = 30;
            break;
    }
    return days;
}

+ (NSInteger)daysOfMonth:(NSInteger)month{
    return [NSDate daysOfMonth:month ofYear:[[NSDate date] year]];
}

+ (NSInteger)daysOfMonthWithDate:(NSDate *)date
{
    NSCalendar *_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *comps = [_calendar components:unitFlags fromDate:date];
    return [NSDate daysOfMonth:[comps month] ofYear:[comps year]];
}


+ (NSDate *)dateWithString:(NSString *)dateString
{
    NSArray *dateCharArray = @[@"年", @"月"];
    NSArray *timeCharArray = @[@"时", @"分", @"点"];
    NSArray *needSpaceCharArray = @[@"日", @"秒"];
    for (int i = 0; i < [dateString length]; i++) {
        //截取字符串中的每一个字符
        NSRange range = NSMakeRange(i, 1);
        NSString *s = [dateString substringWithRange:range];
        if ([dateCharArray containsObject:s]) {
            dateString = [dateString stringByReplacingCharactersInRange:range withString:@"-"];
        }
        if ([timeCharArray containsObject:s]) {
            dateString = [dateString stringByReplacingCharactersInRange:range withString:@":"];
        }
        if ([needSpaceCharArray containsObject:s]) {
            dateString = [dateString stringByReplacingCharactersInRange:range withString:@" "];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([dateString rangeOfString:@":"].location != NSNotFound) {
        formatter.dateFormat = [NSString stringWithFormat:@"%@ %@",WT_DATE_Format, WT_TIME_Format];
    } else {
        formatter.dateFormat = WT_DATE_Format;
    }
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)formatString {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    NSDate *inputDate;
    
    if ([(NSString *)formatString length] > 0) {
        [inputFormatter setDateFormat:formatString];
        inputDate = [inputFormatter dateFromString:dateString];
        return inputDate;
    }
    
    if ([dateString length] < 14 && [dateString length] >= 8) {
        NSString *tempString = [dateString substringToIndex:8];
        [inputFormatter setDateFormat:@"yyyyMMdd"];
        inputDate = [inputFormatter dateFromString:tempString];
    } else if ([dateString length] == 14) {
        [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
        inputDate = [inputFormatter dateFromString:dateString];
    } else if ([dateString length] > 14) {
        NSString *tempString = [dateString substringToIndex:14];
        [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
        inputDate = [inputFormatter dateFromString:tempString];
    }else if ([dateString length] < 8){
        if (dateString.length < 6) {
            return nil;
        }
        NSString *tempString = [dateString substringToIndex:6];
        [inputFormatter setDateFormat:@"yyyyMM"];
        inputDate = [inputFormatter dateFromString:tempString];
    }
    return inputDate;
}

- (NSString *)dateTimeStringWithFormat:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    return [formatter stringFromDate:self];
}

+ (NSDate *)tomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)yesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}


- (NSDate *)monthsAgo:(NSInteger)months{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:-months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:self options:0];
    return newDate;
}

- (NSDate *)monthsLater:(NSInteger)months{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:self options:0];
    return newDate;
}

- (NSDate *)daysAgo:(NSInteger)days{
    return [self dateBySubtractingDays:days];
}

- (NSDate *)daysLater:(NSInteger)days{
    return [self dateByAddingDays:days];
}

- (NSDate *)hoursAgo:(NSInteger)hours{
    return [self dateBySubtractingHours:hours];
}

- (NSDate *)hoursLater:(NSInteger)hours{
    return [self dateByAddingHours:hours];
}

- (NSDate *)minutesAgo:(NSInteger)minutes{
    return [self dateBySubtractingMinutes:minutes];
}

- (NSDate *)minutesLater:(NSInteger)minutes{
    return [self dateByAddingMinutes:minutes];
}

+ (NSDate *)dateWithTimeIntervalString:(NSString *)string{
    return [NSDate dateWithTimeIntervalSince1970:[string longLongValue]];
}

+ (NSDate *)dateWithDifferenceInterval:(NSTimeInterval)interval {
    NSTimeInterval serverTimestamp = [NSDate date].timeIntervalSince1970 + interval;
    return [NSDate dateWithTimeIntervalSince1970:serverTimestamp];
}

+ (NSDictionary *)timeIntervalSinceDate:(NSString *)standardDate withSpan:(NSTimeInterval)span {
    NSDate *d = [NSDate dateWithString:standardDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:d];
    NSDate *fromDate = [d dateByAddingTimeInterval:frominterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *nowDate=[dateFormatter dateFromString:strDate];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: nowDate];
    NSDate *localeDate = [nowDate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] + span - [localeDate timeIntervalSinceReferenceDate];
    
    NSInteger allSeconds    = (int) intervalTime;
    NSInteger days			= allSeconds / D_DAY;
    NSInteger hours			= (allSeconds % D_DAY) / D_HOUR;
    NSInteger minutes		= (allSeconds % D_HOUR) / D_MINUTE;
    NSInteger seconds       = allSeconds % D_MINUTE;

    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:days],@"day",[NSNumber numberWithInteger:hours],@"hour",[NSNumber numberWithInteger:minutes],@"minute",[NSNumber numberWithInteger:seconds],@"second", nil];
}

+ (NSDate *)dateWithMonthsFromNow:(NSInteger)months{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    return newDate;
}

+ (NSDate *)dateWithMonthsBeforeNow:(NSInteger)months{
    return [NSDate dateWithMonthsFromNow:-months];
}

+ (NSDate *)dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    return [NSDate dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *systemTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setYear:year];
    [dateComps setMonth:month];
    [dateComps setDay:day];
    [dateComps setTimeZone:systemTimeZone];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:second];
    return [dateComps date];
}


#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate tomorrow]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate yesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}

- (BOOL) isLeapYear{
    if (((self.year % 4==0 && self.year % 100!=0) || self.year % 400==0)) {
        return YES;
    }
    return NO;
}

#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger) hour
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday - 1;
}

- (NSInteger) year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

+ (NSString *)stringDateWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)stringDateWithToMinuteDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;

}

+ (NSDate *)dateWithYearAndMonth:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [NSString stringWithFormat:@"%@-01",string];
    NSDate *date = [dateFormatter dateFromString:str];
    
    return date;
}

+ (NSString *)dateToStringWtihMonth:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)dateToStringWtihDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)dateToStringWtihDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)dateToYearMonthStringWtihDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

+ (NSString *)dateWithTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    return timeString;
}

+ (NSArray *)dateBeginAndEndWithDate:(NSDate *)date unit:(NSCalendarUnit)unit
{
    if (date == nil) {
        date = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:unit startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSMonthCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @[];
    }
    
    return @[beginDate, endDate];
}



@end
