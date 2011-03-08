//
//  CFADateTime.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFADateTime : CFAObject {
	@private
	uint64_t start;
}

#pragma mark Singleton
-(id)_init;
+(CFADateTime *)sharedManager;

#pragma mark Date & Time
+(int)day;
+(NSString *)dayString;
+(int)hour;
+(NSString *)hourString;
+(int)minute;
+(NSString *)minuteString;
+(int)month;
+(int)millis;
+(NSString *)monthString;
+(int)second;
+(NSString *)secondString;
+(int)year;

+(NSString *)dayName;
+(NSString *)monthName;

@end
