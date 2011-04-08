//
//  CFADateTime.m
//  Created by Travis Kirton
//

#import "CFADateTime.h"
#include <assert.h>
#include <CoreServices/CoreServices.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>

static CFADateTime *cfaDateTime;
static uint64_t starttime;

@interface CFADateTime (private)
NSCalendar *gregorian;
@end

@implementation CFADateTime
GENERATE_SINGLETON(CFADateTime, cfaDateTime);

+(void)load {
	if(VERBOSELOAD) printf("CFADateTime\n");
}

-(id)_init {
	gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] retain];
	starttime = mach_absolute_time();
	return self;
}

#pragma mark Date & Time
+(NSInteger)year{
	NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
	//CFALog(@"year:%d",[dateComponents year]);
	return [dateComponents year];
}

+(NSInteger)month{
	NSDateComponents *dateComponents = [gregorian components:NSMonthCalendarUnit fromDate:[NSDate date]];
	return [dateComponents month];
}

+(NSString *)monthString {
	NSInteger value = [self month];
	NSString *month = @"";
	if (value < 10) {
		month = [NSString stringWithFormat:@"0"];
	}
	month = [month stringByAppendingFormat:@"%d",value];
	return month;
}

+(NSString *)monthName{
	return [[[[[NSDateFormatter alloc] init] autorelease] monthSymbols] objectAtIndex:[self month]-1];
}

+(NSInteger)week{
	NSDateComponents *dateComponents = [gregorian components:NSWeekCalendarUnit fromDate:[NSDate date]];
	return [dateComponents week];
}

+(NSString *)weekString {
	NSInteger value = [self week];
	NSString *week = @"";
	if (value < 10) {
		week = [NSString stringWithFormat:@"0"];
	}
	week = [week stringByAppendingFormat:@"%d",value];
	return week;
}

+(NSInteger)weekday {
	NSDateComponents *dateComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
	return [dateComponents weekday];
}

+(NSString *)weekdayString {
	NSInteger value = [self weekday];
	NSString *weekday = @"";
	if (value < 10) {
		weekday = [NSString stringWithFormat:@"0"];
	}
	weekday = [weekday stringByAppendingFormat:@"%d",value];
	return weekday;
}

+(NSInteger)day{
	NSDateComponents *dateComponents = [gregorian components:NSDayCalendarUnit fromDate:[NSDate date]];
	return [dateComponents day];
}

+(NSString *)dayName{
	return [[[[[NSDateFormatter alloc] init] autorelease] weekdaySymbols] objectAtIndex:[self weekday]-1];
}

+(NSString *)dayString {
	NSInteger value = [self day];
	NSString *day = @"";
	if (value < 10) {
		day = [NSString stringWithFormat:@"0"];
	}
	day = [day stringByAppendingFormat:@"%d",value];
	return day;
}

+(NSInteger)hour{
	NSDateComponents *dateComponents = [gregorian components:NSHourCalendarUnit fromDate:[NSDate date]];
	return [dateComponents hour];
}

+(NSString *)hourString {
	NSInteger value = [self hour];
	NSString *hour = @"";
	if (value < 10) {
		hour = [NSString stringWithFormat:@"0"];
	}
	hour = [hour stringByAppendingFormat:@"%d",value];
	return hour;
}

+(NSInteger)minute{
	NSDateComponents *dateComponents = [gregorian components:NSMinuteCalendarUnit fromDate:[NSDate date]];
	return [dateComponents minute];
}

+(NSString *)minuteString {
	NSInteger value = [self minute];
	NSString *minute = @"";
	if (value < 10) {
		minute = [NSString stringWithFormat:@"0"];
	}
	minute = [minute stringByAppendingFormat:@"%d",value];
	return minute;
}

+(NSInteger)second{
	NSDateComponents *dateComponents = [gregorian components:NSSecondCalendarUnit fromDate:[NSDate date]];
	return [dateComponents second];
}

+(NSString *)secondString {
	NSInteger value = [self second];
	NSString *second = @"";
	if (value < 10) {
		second = [NSString stringWithFormat:@"0"];
	}
	second = [second stringByAppendingFormat:@"%d",value];
	return second;
}

+(NSInteger)millis {
	uint64_t difference = mach_absolute_time() - starttime;
    static double conversion = 0.0;
    
    if( conversion == 0.0 )
    {
        mach_timebase_info_data_t info;
        kern_return_t err = mach_timebase_info( &info );
        
        //Convert the timebase into seconds
        if( err == 0  )
            conversion = 1e-6 * (double) info.numer / (double) info.denom;
    }
    
    return (NSInteger) (conversion * (double) difference);
}

@end
