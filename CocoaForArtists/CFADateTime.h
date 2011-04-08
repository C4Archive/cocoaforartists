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
+(NSInteger)day;
+(NSString *)dayString;
+(NSInteger)hour;
+(NSString *)hourString;
+(NSInteger)minute;
+(NSString *)minuteString;
+(NSInteger)month;
+(NSInteger)millis;
+(NSString *)monthString;
+(NSInteger)second;
+(NSString *)secondString;
+(NSInteger)year;

+(NSString *)dayName;
+(NSString *)monthName;

@end
